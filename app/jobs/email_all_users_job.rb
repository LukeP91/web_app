class EmailAllUsersJob < ActiveJob::Base
  queue_as :mailers

  def perform(user_id, recipient_ids)
    sender = User.find(user_id)
    last_send = 0
    recipient_ids.each do |recipient_id|
      recipient = User.find(receipient_id)
      WelcomeMailer.welcome_email(sender, recipient).deliver_later
      last_send = recipient_id
    end
  rescue
    user_ids = User.in_organization(sender.organization_id).where(id: last_send..recipient_ids.last)
    EmailAllUsersJob.perform_later(user.id, user_ids)
  end
end
