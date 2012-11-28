class Distrito < ActiveRecord::Base
  belongs_to :region
  belongs_to :circunscripcion
  has_many :comunas
  belongs_to :politico
  attr_accessible :numero, :region_id, :nombre, :circunscripcion_id
end
