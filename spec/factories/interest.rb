FactoryGirl.define do
  factory :interest do
    name { "cos#{FFaker::Lorem.word}" }
    category { build :category }
  end
end
