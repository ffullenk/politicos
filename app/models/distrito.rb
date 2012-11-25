class Distrito < ActiveRecord::Base
  belongs_to :region
  belongs_to :circunscripcion
  has_many :comuna
  attr_accessible :numero, :region_id, :nombre, :circunscripcion_id
end
