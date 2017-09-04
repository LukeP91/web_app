FactoryGirl.define do
  factory :hash_tag do
    sequence(:name) { |n| "Ruby#{n}" }
    organization { build :organization }
  end
end
