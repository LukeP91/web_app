class Category < ApplicationRecord
  has_many :interests, through: :users_interests
  has_many :users_interests
  belongs_to :organization

  validates :name, presence: true

  scope :from_organization, ->(organization_id) { where(organization_id: organization_id) }
end
