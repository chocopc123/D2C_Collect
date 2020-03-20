class Genre < ApplicationRecord
    validates :genre_id, {presence: true}
    validates :floor, {presence: true}
    validates :name, {presence: true}
end
