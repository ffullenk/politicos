class AddNombreToDistrito < ActiveRecord::Migration
  def change
    add_column :distritos, :nombre, :string
  end
end
