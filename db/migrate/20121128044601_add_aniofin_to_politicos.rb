class AddAniofinToPoliticos < ActiveRecord::Migration
  def change
    add_column :politicos, :aniofin, :integer
  end
end
