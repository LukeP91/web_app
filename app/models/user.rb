class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :organization
  has_many :interests, through: :users_interests
  has_many :users_interests

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true

  scope :with_age_between, ->(age_range) { where(age: age_range) }
  scope :with_gender, ->(gender) { where(gender: gender) }

  def full_name
    "#{first_name} #{last_name}"
  end

  def interests_list
    interests.pluck(:name).join(', ')
  end

  def values_to_export
    [first_name, last_name, gender, age, interests.map(&:name)].flatten!
  end
end
