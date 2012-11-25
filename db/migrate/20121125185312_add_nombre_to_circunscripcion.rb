class AddNombreToCircunscripcion < ActiveRecord::Migration
  def change
    add_column :circunscripcions, :nombre, :string
  end
end
