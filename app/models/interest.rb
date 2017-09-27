class Interest < ApplicationRecord
  has_many :users, through: :users_interests
  has_many :users_interests
  belongs_to :category
  belongs_to :organization

  validates :name, presence: true

  scope :in_organization, ->(organization) { where(organization: organization) }
  scope :with_category, ->(category) { joins(:category).where(categories: { name: category }) }
  scope :with_name_starting_with, ->(partial_name) { where('interests.name LIKE ?', "#{partial_name}%") }

  delegate :name, to: :category, prefix: true
end
