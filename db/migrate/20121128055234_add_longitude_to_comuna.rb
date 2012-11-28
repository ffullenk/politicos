class AddLongitudeToComuna < ActiveRecord::Migration
  def change
    add_column :comunas, :longitude, :float
  end
end
