class AddNumeroToRegion < ActiveRecord::Migration
  def change
    add_column :regions, :numero, :integer
  end
end
