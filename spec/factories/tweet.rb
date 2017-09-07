FactoryGirl.define do
  factory :tweet do
    user_name 'user_name'
    message 'message'
    sequence(:tweet_id) { |n| n.to_s }
    organization { build(:organization) }
    hash_tags { build_list(:hash_tag, 1) }
    sources { build_list(:source, 1) }
  end
end
