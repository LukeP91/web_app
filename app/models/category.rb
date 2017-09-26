class Category < ApplicationRecord
  has_many :interests
  belongs_to :organization
  has_many :users, through: :interests

  validates :name, presence: true

  scope :in_organization, ->(organization) { where(organization: organization) }
end
