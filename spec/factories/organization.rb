FactoryGirl.define do
  factory :organization do
    name FFaker::Company.name
    subdomain { name }
    initialize_with { Organization.find_or_create_by(id: 1) }
  end
end
