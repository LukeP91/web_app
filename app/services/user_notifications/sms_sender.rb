class UserNotifications::SmsSender < Pattern::ServicePattern
  def initialize(to:, message:)
    @mobile_phone = to
    @message = message
  end

  def call
    TwilioWrapper.new.send_sms(to: @mobile_phone, message: @message)
  end
end
