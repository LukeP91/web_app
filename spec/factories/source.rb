FactoryGirl.define do
  factory :source do
    sequence(:name) { |n| "#Hashtag#{n}" }
    organization { build :organization }
  end
end
