class SendEmail
  def self.send_to(current_user, user)
    LannisterMailer.regards_email(current_user, user).deliver_later
  end
end
