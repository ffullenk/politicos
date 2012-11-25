class AddSenadorToPolitico < ActiveRecord::Migration
  def change
    add_column :politicos, :senador, :boolean
  end
end
