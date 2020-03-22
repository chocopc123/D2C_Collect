class CreateShopsGenres < ActiveRecord::Migration[5.2]
  def change
    create_table :shops_genres do |t|
      t.integer :shop_id
      t.string :genre

      t.timestamps
    end
  end
end
