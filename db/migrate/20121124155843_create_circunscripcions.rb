class CreateCircunscripcions < ActiveRecord::Migration
  def change
    create_table :circunscripcions do |t|
      t.string :numero
      t.integer :region_id

      t.timestamps
    end
  end
end
