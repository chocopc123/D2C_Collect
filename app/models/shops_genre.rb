class ShopsGenre < ApplicationRecord
    validates :shop_id, {presence: true}
    validates :genre, {presence: true, uniqueness: { scope: :shop_id}}
end
