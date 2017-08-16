require 'rails_helper'

describe Api::UsersController do
  describe '#index' do
    context 'authorized user' do
      it 'returns all users from organization' do
        organization = create(:organization)
        create(:user, email: 'joe.doe@example.com', organization: organization)
        create(:user, email: 'alice.doe@example.com', organization: organization)

        get :index

        expect(response).to have_http_status(:ok)
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
      it 'returns user data in proper format' do
        user = create(
          :user,
          first_name: 'Joe',
          last_name: 'Doe',
          email: 'joe.doe@example.com',
          age: 50,
          gender: 'male'
        )

        get :show, params: { id: user.id }

        expect(response).to have_http_status(:ok)
        expect(response.body).to include_json(
          data: {
            id: user.id,
            type: 'users',
            attributes: {
              first_name: 'Joe',
              last_name: 'Doe',
              email: 'joe.doe@example.com',
              age: 50,
              gender: 'male'
            }
          }
        )
      end
    end

    context 'unauthorized user' do
    end
  end

  describe '#create' do
    context 'authorized user' do
      it 'creates new user' do
        create(:organization)
        post :create, params: { user: { first_name: 'Joe', last_name: 'Doe', email: 'joe.doe@example.com', age: 25, gender: 'male' } }

        expect(response).to have_http_status(:created)
        expect(response.body).to include_json(
          first_name: 'Joe',
          last_name: 'Doe',
          email: 'joe.doe@example.com',
          age: 25,
          gender: 'male'
        )
      end
    end
  end

  describe '#edit' do
    context 'authorized user' do
      it 'updates existing user' do
        user = create(
          :user,
          first_name: 'Joe',
          last_name: 'Doe',
          email: 'joe.doe@example.com',
          age: 50,
          gender: 'male'
        )

        put :edit, params: { id: user.id, user: { first_name: 'Alice', last_name: 'Kowalski', email: 'alice.kowalski@example.com', age: 30, gender: 'female' } }

        expect(response).to have_http_status(:ok)
        expect(response.body).to include_json(
          first_name: 'Alice',
          last_name: 'Kowalski',
          email: 'alice.kowalski@example.com',
          age: 30,
          gender: 'female'
        )
      end
    end
  end
end
