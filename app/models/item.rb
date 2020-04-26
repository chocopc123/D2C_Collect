class Item < ApplicationRecord
    validates :name, {presence: true}
    validates :shop_id, {presence: true}
    validates :comment, length: {maximum: 27}
end
