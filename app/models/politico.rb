class Politico < ActiveRecord::Base
  
  attr_accessible :anio, :circunscripcion_id, :distrito_id, :foto, :gmaps, :latitude, :longitude, :profesion, :nombre, :diputado, :senador, :aniofin
end
