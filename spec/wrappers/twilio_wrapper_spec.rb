require 'rails_helper'

describe TwilioWrapper do
  describe '#valid_phone_number?' do
    context 'when phone number is valid' do
      it 'returns true' do
        client = double('TwilioClient')
        allow(client).to receive_message_chain('lookups.v1.phone_numbers.fetch').and_return('data')
        allow(Twilio::REST::Client).to receive(:new).and_return(client)
        expect(TwilioWrapper.new.valid_phone_number?('+48508692030')).to eq true
      end
    end

    context 'when phone number is invalid' do
      it 'returns false' do
        response = double('TwilioResponse')
        allow(response).to receive(:fetch).and_raise(Twilio::REST::RestError.new('post', 'url', 'wrong number'))
        client = double('Twilio Client')
        allow(client).to receive_message_chain('lookups.v1.phone_numbers').and_return(response)
        allow(Twilio::REST::Client).to receive(:new).and_return(client)

        expect(TwilioWrapper.new.valid_phone_number?('Invalid phone')).to eq false
      end
    end
  end
end
