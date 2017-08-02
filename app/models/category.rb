class Category < ApplicationRecord
  has_many :interests, through: :users_interests
  has_many :users_interests
  belongs_to :organization

  validates :name, presence: true

  scope :in_organization, ->(organization) { where(organization: organization) }
end
