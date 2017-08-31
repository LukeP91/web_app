class Source < ApplicationRecord
  belongs_to :organization

  scope :in_organization, ->(organization) { where(organization: organization) }
end
