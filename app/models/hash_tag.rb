class HashTag < ApplicationRecord
  has_many :tweets_hash_tags
  has_many :tweets, through: :tweets_hash_tags

  validates :name, presence: true

  scope :in_organization, HashTagsFromOrganizationQuery
end
