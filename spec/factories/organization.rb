FactoryGirl.define do
  factory :organization do
    sequence(:name) { |n| "Company_#{n}" }
    subdomain { name }
  end
end
