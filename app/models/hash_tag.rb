class HashTag < ApplicationRecord
  has_many :tweets_hash_tags
  has_many :tweets, through: :tweets_hash_tags
  belongs_to :organization

  validates :name, presence: true

  scope :in_organization, ->(organization) { where(organization: organization) }
end
