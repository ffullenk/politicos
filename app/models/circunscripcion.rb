class Circunscripcion < ActiveRecord::Base
  belongs_to :region
  has_many :distrito
  has_many :comunas
  attr_accessible :numero, :region_id, :nombre
end
