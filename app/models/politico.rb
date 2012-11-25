class Politico < ActiveRecord::Base
  acts_as_gmappable
  attr_accessible :anio, :circunscripcion_id, :distrito_id, :foto, :gmaps, :latitude, :longitude, :profesion
end
