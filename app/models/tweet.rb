class Tweet < ApplicationRecord
  has_many :tweets_hash_tags
  has_many :hash_tags, through: :tweets_hash_tags
  has_many :tweets_sources
  has_many :sources, through: :tweets_sources

  validates :user_name, :message, :tweet_id, presence: true

  scope :in_organization, ->(organization) { joins(:sources).where(sources: { organization_id: organization.id }) }
end
