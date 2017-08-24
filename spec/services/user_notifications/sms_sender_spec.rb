require 'rails_helper'

describe UserNotifications::SmsSender do
  describe '.call' do
    it 'sends sms' do
      user = create(
        :user,
        first_name: 'Joe',
        last_name: 'Doe',
        mobile_phone: '+015252525252'
      )
      client = double("Twillio Client")
      messages = double("Messages Double", create:
        {
          from: '+015151515151',
          to: '+015252525252',
          body: 'Welcome Joe Doe!'
        }
      )
      allow(Twilio::REST::Client).to receive(:new) { client }
      allow(client).to receive_message_chain("api.account.messages") { messages }

      UserNotifications::SmsSender.call(user)

      expect(messages).to have_received(:create).with(
        from: '+015151515151',
        to: '+015252525252',
        body: 'Welcome Joe Doe!'
      )
    end
  end
end
