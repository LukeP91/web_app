class Tweet < ApplicationRecord
  has_many :tweets_hash_tags
  has_many :hash_tags, through: :tweets_hash_tags
  has_many :tweets_sources
  has_many :sources, through: :tweets_sources
  belongs_to :organization

  validates :user_name, :message, :tweet_id, presence: true
  validates_uniqueness_of :tweet_id, scope: :organization

  scope :in_organization, ->(organization) { joins(:sources).where(sources: { organization_id: organization.id }) }
  scope :not_sent_to_facebook, -> { where(sent_to_fb: false) }
end
