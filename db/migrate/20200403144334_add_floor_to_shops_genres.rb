class AddFloorToShopsGenres < ActiveRecord::Migration[5.2]
  def change
    add_column :shops_genres, :floor, :integer
  end
end
