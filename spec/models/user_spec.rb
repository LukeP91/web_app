require 'rails_helper'

describe User do
  describe '#validate_phone_number' do
    it 'returns error when phone number is invalid' do
      allow_any_instance_of(TwilioWrapper).to receive(:valid_phone_number?).and_return(false)
      user = build(:user, mobile_phone: 'invalid_phone')

      user.valid?

      expect(user.errors).to have_key(:mobile_phone)
    end
  end
end
