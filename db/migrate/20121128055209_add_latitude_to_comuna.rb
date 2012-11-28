class AddLatitudeToComuna < ActiveRecord::Migration
  def change
    add_column :comunas, :latitude, :float
  end
end
