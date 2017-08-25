class TwilioWrapper
  def initialize
    @twilio_client = Twilio::REST::Client.new
  end

  def valid_phone_number?(phone_number)
    @twilio_client.lookups.v1.phone_numbers(phone_number).fetch('carriers')
    true
  rescue Twilio::REST::RestError
    false
  end

  def send_sms(to:, message:)
    @twilio_client.api.account.messages.create(
      from: Rails.application.secrets.twilio_phone_number,
      to: to,
      body: message
    )
  end
end
