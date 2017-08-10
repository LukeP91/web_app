class EmailAllJob < ActiveJob::Base
  queue_as :mailers

  def perform(user_id, organization_id)
    sender = User.find(user_id)
    users = User.in_organization(Organization.find(organization_id))
    users.each do |user|
      WelcomeMailer.welcome_email(sender, user).deliver_later
    end
  end
end
