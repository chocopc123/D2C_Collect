class AddIconNameColumnToItems < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :icon_name, :string
  end
end
