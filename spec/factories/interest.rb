FactoryGirl.define do
  factory :interest do
    name { "cosm#{FFaker::Lorem.word}" }
    category { build :category }
    organization { build :organization }
  end
end
