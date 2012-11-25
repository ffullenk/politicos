class AddDiputadoToPolitico < ActiveRecord::Migration
  def change
    add_column :politicos, :diputado, :boolean
  end
end
