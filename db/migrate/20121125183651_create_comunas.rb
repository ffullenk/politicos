class CreateComunas < ActiveRecord::Migration
  def change
    create_table :comunas do |t|
      t.string :nombre
      t.integer :region_id
      t.integer :circunscripcion_id
      t.integer :distrito_id

      t.timestamps
    end
  end
end
