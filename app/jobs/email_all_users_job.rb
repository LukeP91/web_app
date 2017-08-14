class EmailAllUsersJob < ActiveJob::Base
  queue_as :mailers

  def perform(user_id, recipient_ids)
    sender = User.find(user_id)
    last_send = Rails.cache.fetch("last_send_email_user_id") do
      0
    end

    if last_send != 0
      recipient_ids = User.in_organization(sender.organization_id).where(id: last_send..recipient_ids.last).pluck()
    end

    user_ids.each do |recipient_id|
      recipient = User.find(recipient_id)
      WelcomeMailer.welcome_email(sender, recipient).deliver_later
      last_send = Rails.cache.set("last_send_email_user_id", recipient_id + 1 )
      end
    end

    Rails.cache.write("last_send_email_user_id", 0)
end
