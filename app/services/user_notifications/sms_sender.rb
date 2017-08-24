class UserNotifications::SmsSender < Pattern::ServicePattern
  def initialize(user)
    @user = user
    @client = Twilio::REST::Client.new
  end

  def call
    send_notification
  end

  private

  attr_reader :user, :client

  def send_notification
    client.api.account.messages.create(
      from: Rails.application.secrets.twilio_phone_number,
      to: user.mobile_phone,
      body: "Welcome #{user.full_name}!"
    )
  end
end
