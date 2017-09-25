class SendEmail < Pattern::ServicePattern
  def initialize(sender, recipient)
    @sender = sender
    @recipient = recipient
  end

  private

  def call
    LannisterMailer.regards_email(sender, recipient).deliver_later
  end

  attr_reader :sender, :recipient
end
