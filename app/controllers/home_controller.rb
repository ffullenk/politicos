# encoding: utf-8
class HomeController < ApplicationController



  def cargar_datos
    url = "http://datos.bcn.cl/sparql?default-graph-uri=&query=PREFIX+rdf%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F1999%2F02%2F22-rdf-syntax-ns%23%3E%0D%0APREFIX+bcngeo%3A+%3Chttp%3A%2F%2Fdatos.bcn.cl%2Fontologies%2Fbcn-geographics%23%3E+%0D%0APREFIX+dc%3A+%3Chttp%3A%2F%2Fpurl.org%2Fdc%2Felements%2F1.1%2F%3E%0D%0ASELECT+%3FnombreRegion+%3FnombreCircuns+%3FnombreDistrito+%3FnombreComuna+++WHERE%7B%0D%0A%0D%0A%3Fcircuns+rdf%3Atype+bcngeo%3ACircumscription+.%0D%0A%3Fcircuns+bcngeo%3AcomposedBy+%3Fcomuna+.%0D%0A%0D%0A%3Fdistrict+rdf%3Atype+bcngeo%3ADistrict+.%0D%0A%3Fdistrict+bcngeo%3AcomposedBy+%3Fcomuna+.%0D%0A%0D%0A%3Fregion+rdf%3Atype+bcngeo%3ARegion%3B%0D%0Abcngeo%3AcomposedBy+%3Fprovincia+.%0D%0A%0D%0A%3Fprovincia+gn%3AofficialName+%3FnombreProvincia+.%0D%0A%3Fprovincia+bcngeo%3AcomposedBy+%3Fcomuna+.%0D%0A%0D%0A%3Fcomuna+gn%3AofficialName+%3FnombreComuna+.%0D%0A%3Fdistrict+gn%3AofficialName+%3FnombreDistrito+.%0D%0A%3Fregion+gn%3AofficialName+%3FnombreRegion+.%0D%0A%3Fcircuns+gn%3AofficialName+%3FnombreCircuns%0D%0A%7D&format=text%2Fhtml&timeout=0&debug=on"
       

    doc = Nokogiri::XML(open(url))
    doc.encoding = 'utf-8'


    details = doc.search('//tr').collect do |row|
    detail = {}
      [
      [:region, 'td[1]/text()'],
      [:circunscripcion, 'td[2]/text()'],
      [:distrito, 'td[3]/text()'],
      [:comuna, 'td[4]/text()']
      ].collect do |name, xpath|

      detail[name] = row.at_xpath(xpath).to_s.strip
      end

    end
  details.shift
  

  #Comuna.delete_all
  #Distrito.delete_all
  #Circunscripcion.delete_all
  #Region.delete_all
  
  details.each do |dato|


      region = Region.find_or_create_by_nombre(:nombre =>dato[0])
      circunscripcion = Circunscripcion.find_or_create_by_nombre(:nombre => dato[1], :region_id =>region.id)
      distrito = Distrito.find_or_create_by_nombre(:nombre=>dato[2], :circunscripcion_id=>circunscripcion.id, :region_id=>region.id)
      
      if validaComuna(dato[3])

       comuna = Comuna.find_or_create_by_nombre(:nombre=>dato[3]+", Chile",:region_id=>region.id, 
        :circunscripcion_id=>circunscripcion.id, :distrito_id=>distrito.id)
    end

  end





end

def searchsenadores

  region = Region.find_by_id(params[:region_id])
  circunscripcion = Circunscripcion.find_by_id(params[:circunscripcion_id])
  anio = params[:date][:year]
  comunasIds = Array.new

 

  if !circunscripcion.nil?
    @senadores = Politico.where("circunscripcion_id = ? AND senador = ? AND diputado = ? AND anio <= ? AND aniofin >= ? ", circunscripcion.id, true,false,anio, anio)
    else
       @senadores = Politico.where("senador = ? AND diputado = ? AND anio <= ? AND aniofin >= ?",true,false,anio,anio)
    
  end

  @senadores.each do |senador|
     
       
    circunscripcion = Circunscripcion.find_by_id(senador.circunscripcion_id)
       
       circunscripcion.comunas.each do |comuna|
          comunasIds.push(comuna.id)
       end
   

  end


  @comunas = Comuna.find_all_by_id(comunasIds)
  @json = @comunas.to_gmaps4rails

  if comunasIds.size.eql? 0
   flash[:notice] = "No se encontraron resultados para la búsqueda."
 else
    flash[:notice] = "Se encontraron "+@senadores.size.to_s + " resultados."
 end
  @render_senadores = true
  @regiones = Region.all
  @circunscripciones = Circunscripcion.all

end


def search

  region = Region.find_by_id(params[:region_id])
  circunscripcion = Circunscripcion.find_by_id(params[:circunscripcion_id])
  distrito = Distrito.find_by_id(params[:distrito_id])

  anio = params[:date][:year]
  comunasIds = Array.new
  @render_todos= true

  if(region.nil?)
   flash[:error] = "Selecccione una región."
   redirect_to root_path
   return
  else
    @regiones = Region.all
    distritos = Distrito.find_all_by_region_id(region.id)
    circunscripciones = Circunscripcion.find_all_by_region_id(region.id)
    @politicos = Array.new

    distritos.each do |distrito|

      ps = Politico.where("distrito_id= ? AND anio <= ? AND aniofin >= ?",distrito.id,anio,anio)
      ps.each do |p|
          @politicos.push(p)
      end
      distrito.comunas.each do |comuna|
      comunasIds.push(comuna.id)
        end

     
    end

    circunscripciones.each do |circunscripcion|

      ps = Politico.where("circunscripcion_id= ? AND anio <= ? AND aniofin >= ?",circunscripcion.id,anio,anio)
       ps.each do |p|
          @politicos.push(p)
      end
       circunscripcion.comunas.each do |comuna|
          comunasIds.push(comuna.id)
       end
    end

    @comunas = Comuna.find_all_by_id(comunasIds)
    @json = @comunas.to_gmaps4rails


   
    


  end


end

def searchdiputados

  region = Region.find_by_id(params[:region_id])
  distrito = Distrito.find_by_id(params[:distrito_id])
  anio = params[:date][:year]
  comunasIds = Array.new

 

  if !distrito.nil?
    @diputados = Politico.where("distrito_id = ? AND senador = ? AND diputado = ? AND anio <= ? AND aniofin >= ? ", distrito.id, false,true,anio, anio)
    else
       @diputados = Politico.where("senador = ? AND diputado = ? AND anio <= ? AND aniofin >= ?",false,true,anio,anio)
    
  end

  @diputados.each do |diputado|
     
       
    distrito = Distrito.find_by_id(diputado.distrito_id)
       
       distrito.comunas.each do |comuna|
          comunasIds.push(comuna.id)
       end
   

  end

  p comunasIds

  @comunas = Comuna.find_all_by_id(comunasIds)
  @json = @comunas.to_gmaps4rails

  if comunasIds.size.eql? 0
   flash[:notice] = "No se encontraron resultados para la búsqueda."
 else
    flash[:notice] = "Se encontraron "+@diputados.size.to_s + " resultados."
 end
  @render_diputados = true
  @regiones = Region.all
  @distritos = Distrito.all
end


def carga_diputados



#Diputados
 url="http://datos.bcn.cl/sparql?default-graph-uri=&query=SELECT+DISTINCT+%3Fnombre+%3Flugar+%3FbeginningYear+%3FendYear+%3Fcargo+%3Ffoto+WHERE%7B%0D%0A%3Fcargo+a+bcnbio%3ADiputado+.%0D%0A%3Fperson+bcnbio%3AhasParliamentaryAppointment+%3Fa+.%0D%0A%3Fperson+foaf%3Aname+%3Fnombre+.%0D%0A%3Fperson+foaf%3Adepiction+%3Ffoto.%0D%0A%3Fa+bcnbio%3AhasPosition+%3Fcargo+.%0D%0A%3Fa+bcnbio%3ArepresentingPlaceNamed+%3Flugar+.%0D%0A%3Fa+a+bcnbio%3APositionPeriod+.%0D%0A%3Fa+bcnbio%3AhasBeginning+%3Fbeginning+.%0D%0A%3Fa+bcnbio%3AhasEnd+%3Fend+.%0D%0A%3Fbeginning+time%3Ayear+%3FbeginningYear+.%0D%0A%3Fend+time%3Ayear+%3FendYear%0D%0AFILTER+%28%3FbeginningYear+%3E+1989%29.+%0D%0A%7D%0D%0AORDER+BY+DESC%28%3FbeginningYear+%29&format=text%2Fhtml&timeout=0&debug=on"

doc = Nokogiri::XML(open(url))
doc.encoding = 'utf-8'

# Search for nodes by xpath
#puts doc.xpath('//entry').at_xpath("summary").content

details = doc.search('//tr').collect do |row|
detail = {}
[
 [:nombre, 'td[1]/text()'],
 [:lugar, 'td[2]/text()'],
 [:beginningYear, 'td[3]/text()'],
 [:endYear, 'td[4]/text()'],
 [:cargo, 'td[5]/text()'],
 [:foto, 'td[6]/text()'],
].collect do |name, xpath|

detail[name] = row.at_xpath(xpath).to_s.strip
end

#p detail
end
details.shift
#p details

details.each do |row|

numero = row[1].scan(/\d/).join


like = "% " + numero.to_s

distrito = Distrito.find(:all, :conditions => ["nombre like ?", like]).first
unless distrito.nil? 
politico = Politico.find_or_create_by_nombre_and_anio(
  :nombre => row[0], :diputado=> true, :senador=>false,
   :foto=> row[5], :anio=>row[2],:aniofin=>row[3], :distrito_id=> distrito.id);
end
end
end

def carga_senadores



#Senadores
 url="http://datos.bcn.cl/sparql?default-graph-uri=&query=SELECT+DISTINCT+%3Fnombre+%3Flugar+%3FbeginningYear+%3FendYear+%3Fcargo+%3Ffoto+WHERE%7B%0D%0A%3Fcargo+a+bcnbio%3ASenador+.%0D%0A%3Fperson+bcnbio%3AhasParliamentaryAppointment+%3Fa+.%0D%0A%3Fperson+foaf%3Aname+%3Fnombre+.%0D%0A%3Fperson+foaf%3Adepiction+%3Ffoto.%0D%0A%3Fa+bcnbio%3AhasPosition+%3Fcargo+.%0D%0A%3Fa+bcnbio%3ArepresentingPlaceNamed+%3Flugar+.%0D%0A%3Fa+a+bcnbio%3APositionPeriod+.%0D%0A%3Fa+bcnbio%3AhasBeginning+%3Fbeginning+.%0D%0A%3Fa+bcnbio%3AhasEnd+%3Fend+.%0D%0A%3Fbeginning+time%3Ayear+%3FbeginningYear+.%0D%0A%3Fend+time%3Ayear+%3FendYear%0D%0AFILTER+%28%3FbeginningYear+%3E+1989%29.+%0D%0A%7D%0D%0AORDER+BY+DESC%28%3FbeginningYear+%29&format=text%2Fhtml&timeout=0&debug=on"
 doc = Nokogiri::XML(open(url))
doc.encoding = 'utf-8'

# Search for nodes by xpath
#puts doc.xpath('//entry').at_xpath("summary").content

details = doc.search('//tr').collect do |row|
detail = {}
[
 [:nombre, 'td[1]/text()'],
 [:lugar, 'td[2]/text()'],
 [:beginningYear, 'td[3]/text()'],
 [:endYear, 'td[4]/text()'],
 [:cargo, 'td[5]/text()'],
 [:foto, 'td[6]/text()'],
].collect do |name, xpath|

detail[name] = row.at_xpath(xpath).to_s.strip
end

#p detail
end
details.shift
#p details

details.each do |row|

numero = row[1].scan(/\d/).join
p numero

like = "% " + numero.to_s

circunscripcion = Circunscripcion.find(:all, :conditions => ["nombre like ?", like]).first

unless circunscripcion.nil? 
politico = Politico.find_or_create_by_nombre_and_anio(
  :nombre => row[0], :diputado=> false, :senador=>true,
   :foto=> row[5], :anio=>row[2],:aniofin=>row[3], :circunscripcion_id=> circunscripcion.id);
end
end




end


def validaComuna(nombreComuna)
ciudades = ["Arica","Iquique","Calama","Antofagasta","Copiapó","Caldera","La Serena","Coquimbo","Los Vilos","Quillota","Los Andes","Quilpué","Valparaíso","Viña Del Mar","Casablanca","Pudahuel","Renca","Quinta Normal","Independencia","Estación Central","Santiago","Buin","Melipilla","Providencia","Las Condes","La Reina","San Joaquín","La Florida","La Cisterna","Pedro Aguirre Cerda","Puente Alto","Rancagua","Rengo","San Vicente","Pichilemu","Curicó","Talca","Maule","Linares","Cauquenes","Yumbel","Talcahuano","Concepción","Coronel","Chillán","Arauco","Los Ángeles","Traiguén","Victoria","Temuco","Pitrufquén","Villarica","Valdivia","Los Lagos","Osorno","Puerto Varas","Puerto Montt","Castro","O'higgins","Punta Arenas"]

return ciudades.include? nombreComuna

end


  def index

    cargar_datos
    carga_diputados
    carga_senadores

  	@regiones = Region.all
    @distritos = Distrito.all
     @render_todos = true
    @json = Comuna.all.to_gmaps4rails

    
    
    

  end


  def update_distritos
  @distritos = Distrito.where(:region_id => params[:region_id])
  render :partial => "distritos", :object => @distritos
	end


	def update_circunscripciones
  @circunscripciones = Circunscripcion.where(:region_id => params[:region_id])
  render :partial => "circunscripciones", :object => @circunscripciones
	end

  def senadores
    @render_senadores = true
    @regiones = Region.all
    @circunscripciones = Circunscripcion.all
    @senadores = Politico.where(:senador => true)
    comunasIds= Array.new

    @senadores.each do |senador|
       circunscripcion = Circunscripcion.find_by_id(senador.circunscripcion_id)
       
       circunscripcion.comunas.each do |comuna|
          comunasIds.push(comuna.id)
       end
   

    end

    @comunas = Comuna.find_all_by_id(comunasIds)


   

    @json = @comunas.to_gmaps4rails
  end

  def diputados

     @render_diputados = true
    @regiones = Region.all
    @distritos = Distrito.all
    @diputados = Politico.where(:diputado => true)
    comunasIds= Array.new

    @diputados.each do |diputado|
       distrito = Distrito.find_by_id(diputado.distrito_id)
       
       distrito.comunas.each do |comuna|
          comunasIds.push(comuna.id)
       end
   

    end

    @comunas = Comuna.find_all_by_id(comunasIds)


   

    @json = @comunas.to_gmaps4rails
  end


end
