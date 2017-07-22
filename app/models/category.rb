class Category < ApplicationRecord
  has_many :interests, through: :users_interests
  has_many :users_interests

  validates :name, presence: true
end
