class HashTag < ApplicationRecord
  has_many :tweets_hash_tags
  has_many :tweets, through: :tweets_hash_tags

  validates :name, presence: true

  scope :in_organization, ->(organization) { HashTagsFromOrganizationQuery.call(organization: organization) }

  def self.tweets_count_per_hashtag(organization)
    tweets_per_hash_tag = {}
    HashTag.in_organization(organization).each { |tag| tweets_per_hash_tag[tag.name.to_sym] = tag.tweets.count }
    tweets_per_hash_tag
  end
end
