FactoryGirl.define do
  factory :category do
    name { %w[health hobby work].sample }
    initialize_with { Category.find_or_create_by(name: %w[health hobby work].sample) }
  end
end
