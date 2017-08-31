class Source < ApplicationRecord
  belongs_to :organization
  has_many :tweets_sources
  has_many :tweets, through: :tweets_sources

  scope :in_organization, ->(organization) { where(organization: organization) }
end
