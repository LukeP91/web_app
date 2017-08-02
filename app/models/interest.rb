class Interest < ApplicationRecord
  has_many :users, through: :users_interests
  has_many :users_interests
  belongs_to :category

  validates :name, presence: true

  scope :with_category, ->(category) { joins(:category).where(categories: { name: category }) }
  scope :with_name_starting_with, ->(partial_name) { where('interests.name LIKE ?', "#{partial_name}%") }

  delegate :name, to: :category, prefix: true

  def self.female_interests_count(organization_id)
    users = User.from_current_user_organization(organization_id).with_gender('female').with_age_between(20..30)
    with_name_starting_with('cosm').with_category('health').joins(:users_interests)
                                   .where(users_interests: { user_id: users }).count
  end
end
