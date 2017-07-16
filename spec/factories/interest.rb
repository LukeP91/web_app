FactoryGirl.define do
  factory :interest do
    name { "cos#{FFaker::Lorem.word}" }
    category { %w(health hobby work).sample }
  end
end
