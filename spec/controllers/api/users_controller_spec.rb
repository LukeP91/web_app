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

  describe '#show' do
    context 'authorized user' do
      it 'returns user data' do
        user = create(
          :user,
          first_name: 'Joe',
          last_name: 'Doe',
          email: 'joe.doe@example.com',
          age: 50,
          gender: 'male'
        )

        get :show, params: { id: user.id }

        expect(response.body).to include_json(
          first_name: 'Joe',
          last_name: 'Doe',
          email: 'joe.doe@example.com',
          age: 50,
          gender: 'male'
        )
      end
    end

    context 'unauthorized user' do
    end
  end
end
