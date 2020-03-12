class Shop < ApplicationRecord
    has_secure_password
    validates :name, {presence: true, uniqueness: true}
    validates :url, {presence: true, uniqueness: true}
    validates :email, {presence: true, uniqueness: true}
end
