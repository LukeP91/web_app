require 'rails_helper'

describe UserNotifications::SmsSender do
  describe '.call' do
    it 'sends sms' do
      expect_any_instance_of(TwilioWrapper).to receive(:send_sms).with(to: '+015252525252', message: 'Welcome Joe Doe!')

      UserNotifications::SmsSender.call(to: '+015252525252', message: 'Welcome Joe Doe!')
    end
  end
end
