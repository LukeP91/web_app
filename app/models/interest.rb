class Interest < ApplicationRecord
  has_many :users
  belongs_to :category

  validates :name, presence: true

  scope :with_category, ->(category) { where(category: category.name) }
  scope :with_name_starting_with, ->(partial_name) { where("name LIKE ?", "#{partial_name}%") }

  def self.female_interests_count
    users = User.with_gender("female").with_age_between(20..30)
    with_category("health").with_name_starting_with("cosm").where(user_id: users).count
  end
end
