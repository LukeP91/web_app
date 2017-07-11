class Interest < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :category, presence: true

  scope :with_category, ->(category) { where(category: category) }
  scope :with_name_starting_with, ->(name_substring) { where("name LIKE ?", "#{name_substring}%") }

  def self.count_of_interests
    users = User.with_gender("female").with_age_between(20..30)
    with_category("health").with_name_starting_with("cosm").where(user_id: users).count
  end
end
