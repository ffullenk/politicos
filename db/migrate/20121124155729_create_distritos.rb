class CreateDistritos < ActiveRecord::Migration
  def change
    create_table :distritos do |t|
      t.string :numero
      t.string :region_id

      t.timestamps
    end
  end
end
