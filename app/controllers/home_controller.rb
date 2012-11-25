
# encoding: UTF-8
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
  

  Comuna.delete_all
  Distrito.delete_all
  Circunscripcion.delete_all
  Region.delete_all
  
  details.each do |dato|


      region = Region.find_or_create_by_nombre(dato[0])
      circunscripcion = Circunscripcion.find_or_create_by_nombre(dato[1])
      distrito = Distrito.find_or_create_by_nombre(dato[2])
      comuna = Comuna.find_or_create_by_nombre(dato[3])

      comuna.region = region
      comuna.distrito = distrito
      comuna.circunscripcion = circunscripcion

      distrito.region = region
      distrito.circunscripcion = circunscripcion

      circunscripcion.region = region

      comuna.save
      distrito.save
      circunscripcion.save

      p "guardando dato"

  end

end
  def index

    cargar_datos

  	@regiones = Region.all
    @distritos = Distrito.all
     @render_todos = true
     @json = Politico.all.to_gmaps4rails

    
    
    

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
    @json = Politico.where(:senador => true).to_gmaps4rails
  end

  def diputados

     @render_diputados = true
     @regiones = Region.all
    @distritos = Distrito.all
     @json = Politico.where(:diputado => true).to_gmaps4rails
  end


end
