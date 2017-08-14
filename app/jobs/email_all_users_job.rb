class EmailAllUsersJob < ActiveJob::Base
  queue_as :mailers

  def perform(sender_id)
    sender = User.find(sender_id)
    last_send_user_id = Rails.cache.fetch(:last_send_email_user_id) { 0 }

    User.in_organization(sender.organization_id).where('id > ?', last_send_user_id).each do |recipient|
      WelcomeMailer.welcome_email(sender, recipient).deliver_later
      last_send_user_id = Rails.cache.write(:last_send_email_user_id, recipient.id + 1)
    end

    Rails.cache.write(:last_send_email_user_id, 0)
  end
end
