require 'factory_girl_rails'

namespace :db do
  desc 'This task populate db with seed data'
  task :populate, %i[org_name org_subdomain admin_mail admin_password] => :environment do |_task, args|
    organization = FactoryGirl.create(
      :organization,
      name: args.org_name,
      subdomain: args.org_subdomain
    )

    FactoryGirl.create(
      :admin,
      email: args.admin_mail,
      password: args.admin_password,
      password_confirmation: args.admin_password,
      organization: organization
    )

    5.times do
      FactoryGirl.create(
        :user_with_interests,
        :male,
        :older_than_30,
        organization: organization
      )

      FactoryGirl.create(
        :user_with_interests,
        :male,
        :younger_than_20,
        organization: organization
      )

      FactoryGirl.create(
        :user_with_interests,
        :male,
        :between_20_and_30,
        organization: organization
      )

      FactoryGirl.create(
        :user_with_interests,
        :female,
        :older_than_30,
        organization: organization
      )

      FactoryGirl.create(
        :user_with_interests,
        :female,
        :younger_than_20,
        organization: organization
      )

      FactoryGirl.create(
        :user_with_interests,
        :female,
        :between_20_and_30,
        organization: organization
      )
    end
  end
end
