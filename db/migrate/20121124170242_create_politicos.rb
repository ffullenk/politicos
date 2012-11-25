class CreatePoliticos < ActiveRecord::Migration
  def change
    create_table :politicos do |t|
      t.float :latitude
      t.float :longitude
      t.boolean :gmaps
      t.string :foto
      t.integer :anio
      t.string :profesion
      t.integer :circunscripcion_id
      t.integer :distrito_id

      t.timestamps
    end
  end
end
