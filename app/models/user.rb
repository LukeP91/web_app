class User < ApplicationRecord
  include PgSearch

  USERS_PER_PAGE = 30

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :organization
  has_many :interests, through: :users_interests
  has_many :users_interests

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true

  scope :in_organization, ->(organization) { where(organization: organization) }
  scope :with_age_between, ->(age_range) { where(age: age_range) }
  scope :with_gender, ->(gender) { where(gender: gender) }

  pg_search_scope :search_by, against: %i[first_name last_name email age gender], using: { tsearch: { any_word: true } }

  paginates_per USERS_PER_PAGE

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
