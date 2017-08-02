FactoryGirl.define do
  factory :interest do
    name { "cosm#{FFaker::Lorem.word}" }
    organization { build :organization }
    category { build :category, organization: organization }
  end
end
