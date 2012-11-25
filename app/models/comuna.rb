class Comuna < ActiveRecord::Base
	belongs_to :region
	belongs_to :circunscripcion
	belongs_to :distrito
  attr_accessible :circunscripcion, :distrito, :nombre, :region
end
