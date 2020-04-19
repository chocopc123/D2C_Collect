class AddContentColumnToShops < ActiveRecord::Migration[5.2]
  def change
    add_column :shops, :content, :string
  end
end
