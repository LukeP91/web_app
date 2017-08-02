FactoryGirl.define do
  factory :category do
    name { %w[health hobby work].sample }
    organization { build :organization }
  end
end
