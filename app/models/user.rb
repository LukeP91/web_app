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
  validate :validate_phone_number

  scope :in_organization, ->(organization) { where(organization: organization) }
  scope :with_age_between, ->(age_range) { where(age: age_range) }
  scope :with_gender, ->(gender) { where(gender: gender) }

  delegate :facebook_auth_expired?, to: :organization

  pg_search_scope :search_by, against: %i[first_name last_name email age gender], using: { tsearch: { any_word: true } }

  paginates_per USERS_PER_PAGE

  def self.per_page
    20
  end

  def self.pages(per_page = self.per_page)
    (count / per_page.to_f).ceil
  end

  def self.paginate(page: 1, per_page: self.per_page)
    page_offset = (page - 1) * per_page
    limit(per_page).offset(page_offset)
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def interests_list
    interests.pluck(:name).join(', ')
  end

  def values_to_export
    [first_name, last_name, email, gender, age, interests.map(&:name)].flatten!
  end

  def json_web_token
    ::JsonWebToken.encode(id: id)
  end

  def validate_phone_number
    if mobile_phone.present?
      unless TwilioWrapper.new.valid_phone_number?(mobile_phone)
        errors.add(:mobile_phone, 'Given mobile phone is invalid')
      end
    end
  end
end
