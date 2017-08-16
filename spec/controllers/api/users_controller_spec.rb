require 'rails_helper'

describe Api::UsersController do
  describe '#index' do
    context 'authorized user' do
      it 'returns all users from organization' do
        organization = create(:organization)
        create(:user, email: 'joe.doe@example.com', organization: organization)
        create(:user, email: 'alice.doe@example.com', organization: organization)

        get :index

        expect(response.body).to include_json(
          [
            {email: 'joe.doe@example.com'},
            {email: 'alice.doe@example.com'}
          ]
        )
      end
    end

    context 'unauthorized user' do
    end
  end
end
