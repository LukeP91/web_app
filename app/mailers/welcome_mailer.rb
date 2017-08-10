class WelcomeMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def welcome_email(sender, recipient)
    @sender = sender
    mail(from: @sender.email, to: recipient.email, subject: "Welcome!")
  end
end
