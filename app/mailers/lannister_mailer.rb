class LannisterMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def regards_email(sender, recipient)
    @sender = sender
    mail(to: recipient.email, subject: "#{sender.email} sends his regards")
  end
end
