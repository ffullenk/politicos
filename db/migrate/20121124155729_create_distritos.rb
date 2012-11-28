class CreateDistritos < ActiveRecord::Migration
  def change
    create_table :distritos do |t|
      t.string :numero
      t.integer :region_id

      t.timestamps
    end
  end
end
