include FactoryGirl

create(:admin)

200.times do
  create(:user_with_interests, :male, :older_than_30)

  create(:user_with_interests, :male, :younger_than_20)

  create(:user_with_interests, :male, :between_20_and_30)

  create(:user_with_interests, :female, :older_than_30)

  create(:user_with_interests, :female, :younger_than_20)

  create(:user_with_interests, :female, :between_20_and_30)
end
