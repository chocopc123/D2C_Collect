class Review < ApplicationRecord
    validates :user_id, {presence: true}
    validates :shop_id, {presence: true}
    validates :content, {presence: true}
end
