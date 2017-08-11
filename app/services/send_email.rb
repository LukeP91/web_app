class SendEmail
  def initialize(sender, recipient)
    @sender = sender
    @recipient = recipient
  end

  def call
    LannisterMailer.regards_email(sender, recipient).deliver_later
  end

  private

  attr_reader :sender, :recipient
end
