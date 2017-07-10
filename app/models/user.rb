class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :interests, dependent: :destroy, inverse_of: :user

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true

  accepts_nested_attributes_for :interests, reject_if: :all_blank, allow_destroy: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def interests_list
    interests.map(&:name).join(', ')
  end
end
