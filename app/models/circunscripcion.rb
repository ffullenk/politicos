class Circunscripcion < ActiveRecord::Base
  belongs_to :region
  has_many :distrito
  has_many :comuna
  attr_accessible :numero, :region_id, :nombre
end
