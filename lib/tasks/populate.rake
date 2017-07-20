require 'factory_girl_rails'

namespace :db do
  desc "This task populate db with seed data"
  task populate: :environment do

    FactoryGirl.create(:admin)

    10.times do
      FactoryGirl.create(:user_with_interests, :male, :older_than_30)

      FactoryGirl.create(:user_with_interests, :male, :younger_than_20)

      FactoryGirl.create(:user_with_interests, :male, :between_20_and_30)

      FactoryGirl.create(:user_with_interests, :female, :older_than_30)

      FactoryGirl.create(:user_with_interests, :female, :younger_than_20)

      FactoryGirl.create(:user_with_interests, :female, :between_20_and_30)
    end
  end
end
