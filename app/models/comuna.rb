class Comuna < ActiveRecord::Base
	belongs_to :region
	belongs_to :circunscripcion
	belongs_to :distrito
  attr_accessible :circunscripcion_id, :distrito_id, :nombre, :region_id
end
