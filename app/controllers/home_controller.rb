class HomeController < ApplicationController
  def index


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
