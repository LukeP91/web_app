class Organization < ApplicationRecord
  has_many :users
  has_many :interests
  has_many :categories
  has_many :sources
  has_many :hash_tags

  validates :name, presence: true
  validates :subdomain, presence: true
end
