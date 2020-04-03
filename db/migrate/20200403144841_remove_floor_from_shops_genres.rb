class RemoveFloorFromShopsGenres < ActiveRecord::Migration[5.2]
  def change
    remove_column :shops_genres, :floor, :integer
  end
end
