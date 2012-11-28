class AddNombreToPoliticos < ActiveRecord::Migration
  def change
    add_column :politicos, :nombre, :string
  end
end
