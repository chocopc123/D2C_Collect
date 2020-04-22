class Item < ApplicationRecord
    validates :name, {presence: true}
    validates :shop_id, {presence: true}
end
