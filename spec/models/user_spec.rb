require 'rails_helper'

describe User do
  describe '#validate_phone_number' do
    it 'returns error when phone number is invalid' do
      response = double('Twilio Response')
      allow(response).to receive(:fetch).with('carriers').and_raise(Twilio::REST::RestError.new('post', 'url', 'wrong number'))
      twilio_client = double('Twilio Client')
      allow(twilio_client).to receive_message_chain('lookups.v1.phone_numbers').and_return(response)
      allow(Twilio::REST::Client).to receive(:new).and_return(twilio_client)
      user = build(:user, mobile_phone: 'invalid_phone')

      user.valid?

      expect(user.errors).to have_key(:mobile_phone)
    end
  end
end
