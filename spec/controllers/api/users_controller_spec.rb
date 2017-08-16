require 'rails_helper'

describe Api::UsersController do
  describe '#index' do
    context 'authorized user' do
      it 'returns all users from organization' do
        organization = create(:organization)
        joe = create(
          :user,
          first_name: 'Joe',
          last_name: 'Doe',
          email: 'joe.doe@example.com',
          age: 50,
          gender: 'male'
        )

        alice = create(
          :user,
          first_name: 'Alice',
          last_name: 'Cooper',
          email: 'alice.cooper@example.com',
          age: 60,
          gender: 'male'
        )

        get :index

        expect(response).to have_http_status(:ok)
        expect(response.body).to include_json(
          data: [
            {
              id: joe.id,
              type: 'users',
              attributes: {
                first_name: 'Joe',
                last_name: 'Doe',
                email: 'joe.doe@example.com',
                age: 50,
                gender: 'male'
              },
              links: {
                'self' => "http://test.host/admin/users/#{user.id}",
                related: {
                  href: "http://test.host/admin/users/#{user.id}",
                  meta: { count: 1 }
                }
              }
            },
            {
              id: alice.id,
              type: 'users',
              attributes: {
                first_name: 'Alice',
                last_name: 'Cooper',
                email: 'alice.cooper@example.com',
                age: 60,
                gender: 'male'
              },
              links: {
                'self' => "http://test.host/admin/users/#{user.id}",
                related: {
                  href: "http://test.host/admin/users/#{user.id}",
                  meta: { count: 1 }
                }
              }
            }
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
        interest = create(:interest)

        user = create(
          :user,
          first_name: 'Joe',
          last_name: 'Doe',
          email: 'joe.doe@example.com',
          age: 50,
          gender: 'male',
          interests: [interest]
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
            },
            links: {
              'self' => "http://test.host/admin/users/#{user.id}",
              related: {
                href: "http://test.host/admin/users/#{user.id}",
                meta: { count: 1 }
              }
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
