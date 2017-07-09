class Interest < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :category, presence: true
end
