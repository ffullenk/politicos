class AddCircunscripcionToDistrito < ActiveRecord::Migration
  def change
    add_column :distritos, :circunscripcion_id, :integer
  end
end
