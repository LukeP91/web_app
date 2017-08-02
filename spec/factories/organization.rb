FactoryGirl.define do
  factory :organization do
    name FFaker::Company.name
    subdomain { name }
  end
end
