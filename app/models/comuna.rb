class Comuna < ActiveRecord::Base
	belongs_to :region
	belongs_to :circunscripcion
	belongs_to :distrito
  attr_accessible :circunscripcion_id, :distrito_id, :nombre, :region_id, :latitude, :longitude, :gmaps

acts_as_gmappable :process_geocoding => :geocode?,
                  :address => "nombre",
                 :msg => "Disculpa, no podemos localizar esto"

def geocode?
  (!nombre.blank? && (latitude.blank? || longitude.blank?)) || nombre_changed?
end

end
