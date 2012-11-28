class AddLinkToPoliticos < ActiveRecord::Migration
  def change
    add_column :politicos, :link, :string
  end
end
