class Distrito < ActiveRecord::Base
  belongs_to :region
  attr_accessible :numero, :region_id
end
