class EmailAllUsersJob < ActiveJob::Base
  queue_as :mailers

  def perform(sender_id)
    sender = User.find(sender_id)
    last_send_user_id = Redis.current.get(:last_send_email_user_id) || 0

    User.in_organization(sender.organization_id).order(:id).where('id > ?', last_send_user_id).each do |recipient|
      WelcomeMailer.welcome_email(sender, recipient).deliver_later
      Redis.current.set(:last_send_email_user_id, recipient.id)
    end

    Redis.current.set(:last_send_email_user_id, 0)
  end
end
