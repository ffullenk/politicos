class Region < ActiveRecord::Base
  attr_accessible :nombre, :numero
  has_many :circunscripcion
  has_many :comuna
  has_many :distrito
end
