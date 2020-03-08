class AddIconNameColumnToShops < ActiveRecord::Migration[5.2]
  def change
    add_column :shops, :icon_name, :string
  end
end
