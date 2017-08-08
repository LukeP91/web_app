FactoryGirl.define do
  factory :organization do
    name { |n| "Company_#{n}" }
    subdomain { name }
  end
end
