FactoryGirl.define do
  factory :interest do
    sequence(:name) { |n| "cosmetics_#{n}" }
    organization { build :organization }
    category { build :category, organization: organization }
  end
end
