FactoryGirl.define do
  factory :category do
    name { %w(health hobby work).sample }
  end
end
