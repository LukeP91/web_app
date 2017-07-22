class Organization < ApplicationRecord
  has_many :users
  has_many :interests
  has_many :categories

  validates :name, presence: true
  validates :subdomain, presence: true
end
