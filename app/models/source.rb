class Source < ApplicationRecord
  belongs_to :organization
  has_many :tweets_sources
  has_many :tweets, through: :tweets_sources

  validates :name, presence: true, format: { with: /\A#\w*\z/ }

  scope :in_organization, ->(organization) { where(organization: organization) }
end
