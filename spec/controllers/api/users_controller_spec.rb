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
          gender: 'male',
          organization: organization
        )

        alice = create(
          :user,
          first_name: 'Alice',
          last_name: 'Cooper',
          email: 'alice.cooper@example.com',
          age: 60,
          gender: 'male',
          organization: organization
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
                self: "http://test.host/admin/users/#{joe.id}"
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
                self: "http://test.host/admin/users/#{alice.id}"
              }
            }
          ]
        )
      end

      it 'returns paginated users with proper links' do
        organization = create(:organization)
        create_list(:user, 2)
        alice = create(
          :user,
          first_name: 'Alice',
          last_name: 'Cooper',
          email: 'alice.cooper@example.com',
          age: 60,
          gender: 'male'
        )
        create_list(:user, 2)

        get :index, params: { page: 3, per_page: 1 }

        expect(response).to have_http_status(:ok)
        expect(response.header['X-Total-Count']).to eq 5
        expect(response.header['Link']).to include "<http://test.host/admin/users?page=1&per_page=1>; rel=\"first\""
        expect(response.header['Link']).to include "<http://test.host/admin/users?page=5&per_page=1>; rel=\"last\""
        expect(response.header['Link']).to include "<http://test.host/admin/users?page=2&per_page=1>; rel=\"prev\""
        expect(response.header['Link']).to include "<http://test.host/admin/users?page=4&per_page=1>; rel=\"next\""
        expect(response.body).to include_json(
          data: [
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
                self: "http://test.host/admin/users/#{alice.id}"
              }
            }
          ]
        )
      end

      it "returns empty 'Link' response header when there is only one page" do
        get :index

        expect(response.header['Link']).to eq ''
      end

      it "doesn't return link to first page if already on it" do
        create_list(:user, 2)

        get :index, params: {page: 1, per_page: 1}

        expect(response.header['Link']).to_not include "<http://test.host/admin/users?page=1&per_page=1>; rel=\"first\""
      end

      it "doesn't return link to last page if already on it" do
        create_list(:user, 2)

        get :index, params: {page: 2, per_page: 1}

        expect(response.header['Link']).to_not include "<http://test.host/admin/users?page=2&per_page=1>; rel=\"last\""
      end

      it "doesn't return link to previous page if currently on first page" do
        create_list(:user, 2)

        get :index, params: {page: 1, per_page: 1}

        expect(response.header['Link']).to_not include "<http://test.host/admin/users?page=1&per_page=1>; rel=\"prev\""
      end

      it "doesn't return link to next page if currently on last page" do
        create_list(:user, 2)

        get :index, params: {page: 2, per_page: 1}

        expect(response.header['Link']).to_not include "<http://test.host/admin/users?page=2&per_page=1>; rel=\"next\""
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
              self: "http://test.host/admin/users/#{user.id}"
            }
          }
        )
      end

      it 'returns not found when user with given id does not exist in the DB' do
        get :show, params: { id: 1 }

        expect(response).to have_http_status(:not_found)
        expect(response.body).to include_json(
          errors: [
            {
              status: 404,
              code: 'Not found',
              title: 'User not found'
            }
          ]
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
