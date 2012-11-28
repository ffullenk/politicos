class AddGmapsToComuna < ActiveRecord::Migration
  def change
    add_column :comunas, :gmaps, :boolean
  end
end
