class Politico < ActiveRecord::Base
  has_one :circunscripcion
  has_one :distrito
  attr_accessible :anio, :circunscripcion_id, :distrito_id, :distrito,
  :foto, :gmaps, :latitude, :longitude, :profesion, :nombre, 
  :diputado, :senador, :aniofin, :link


  def senador?
  	senador
  end
  def diputado?
  	diputado
  end
end
