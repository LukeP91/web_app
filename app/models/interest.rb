class Interest < ApplicationRecord
  has_many :users, through: :users_interests
  has_many :users_interests
  belongs_to :category

  validates :name, presence: true

  scope :with_category, ->(category) { joins(:category).where(categories: { name: category }) }
  scope :with_name_starting_with, ->(partial_name) { where("name LIKE ?", "#{partial_name}%") }

  def self.female_interests_count
    users = User.with_gender("female").with_age_between(20..30)
    with_name_starting_with("cosm").with_category("Health").where(user_id: users).count
  end
end
