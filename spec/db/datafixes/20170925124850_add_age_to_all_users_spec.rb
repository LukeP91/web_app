require 'rails_helper'
require Rails.root.join('db', 'datafixes', '20170925124850_add_age_to_all_users')

describe Datafixes::AddAgeToAllUsers do
  describe '.up' do
    context 'when user has no age' do
      it 'assign random value between 1 and 50 as his age' do
        user = build(:user, age: nil)
        user.save(validate: false)

        Datafixes::AddAgeToAllUsers.up

        expect(User.where(age: nil).count).to eq 0
        expect(user.reload.age).to be_between(1, 50)
      end
    end

    context 'when user already has age' do
      it 'does not update such user' do
        user = create(:user, age: 25)

        expect do
          Datafixes::AddAgeToAllUsers.up
        end.not_to change { user.reload.age }
      end
    end
  end
end
