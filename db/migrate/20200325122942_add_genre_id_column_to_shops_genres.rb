class AddGenreIdColumnToShopsGenres < ActiveRecord::Migration[5.2]
  def change
    add_column :shops_genres, :genre_id, :integer
  end
end
