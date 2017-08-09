FactoryGirl.define do
  factory :user do
    sequence(:first_name) { |n| "Andrew#{n}" }
    sequence(:last_name)  { |n| "Kowalski#{n}" }
    sequence(:email) { |n| "#{first_name}.#{last_name}_#{n}@example.com".downcase }
    admin false
    password 'password'
    password_confirmation 'password'
    organization { build :organization }

    factory :admin do
      email 'admin@example.com'
      admin true
    end

    trait :female do
      gender 'female'
    end

    trait :male do
      gender 'male'
    end

    trait :older_than_30 do
      age { Random.new.rand(31..100) }
    end

    trait :younger_than_20 do
      age { Random.new.rand(2..19) }
    end

    trait :between_20_and_30 do
      age { Random.new.rand(20..30) }
    end

    factory :user_with_interests do
      transient do
        interests_count 5
      end

      after(:create) do |user, evaluator|
        interests_list = create_list(:interest, evaluator.interests_count, organization: user.organization)
        user.interests = interests_list
      end
    end
  end
end
