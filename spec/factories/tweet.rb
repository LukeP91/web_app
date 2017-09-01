FactoryGirl.define do
  factory :tweet do
    user_name 'user_name'
    message 'message'
    sequence(:tweet_id) { |n| "#{n}" }
    hash_tags { create_list(:hash_tag, 1) }
    sources { create_list(:source, 1) }
  end
end
