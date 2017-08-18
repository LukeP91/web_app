require 'rails_helper'

describe Api::UsersController do
  describe '#index' do
    context 'when user is authorized' do
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

        create(
          :user,
          first_name: 'Dave',
          last_name: 'Joe',
          email: 'dave.joe@example.com',
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
        create_list(:user, 2, organization: organization)
        alice = create(
          :user,
          first_name: 'Alice',
          last_name: 'Cooper',
          email: 'alice.cooper@example.com',
          age: 60,
          gender: 'male',
          organization: organization
        )
        create_list(:user, 2, organization: organization)

        get :index, params: { page: 3, per_page: 1 }

        expect(response).to have_http_status(:ok)
        expect(response.body).to include_json(
          links: {
            self: 'http://test.host/admin/users',
            first: 'http://test.host/admin/users?page=1&per_page=1',
            prev: 'http://test.host/admin/users?page=2&per_page=1',
            next: 'http://test.host/admin/users?page=4&per_page=1',
            last: 'http://test.host/admin/users?page=5&per_page=1'
          },
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

      describe 'links section' do
        context 'where there is only one page' do
          it 'returns only self' do
            get :index

            expect(json.fetch('links')).to eq('self' => 'http://test.host/admin/users')
          end
        end

        context 'when currently on first page' do
          it "doesn't return link to first page" do
            create_list(:user, 2)

            get :index, params: { page: 1, per_page: 1 }

            expect(json.fetch('links')).to_not have_key('first')
          end

          it "doesn't return link to previous page" do
            create_list(:user, 2)

            get :index, params: { page: 1, per_page: 1 }

            expect(json.fetch('links')).to_not have_key('prev')
          end
        end

        context 'when currently on last page' do
          it "doesn't return link to next page" do
            create_list(:user, 2)

            get :index, params: { page: 2, per_page: 1 }

            expect(json.fetch('links')).to_not have_key('next')
          end

          it "doesn't return link to last page" do
            create_list(:user, 2)

            get :index, params: { page: 2, per_page: 1 }

            expect(json.fetch('links')).to_not have_key('last')
          end
        end
      end
    end

    context 'when user is unauthorized' do
      xit 'returns unauthorized'
    end
  end

  describe '#show' do
    context 'when user is authorized' do
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
            },
            links: {
              self: "http://test.host/admin/users/#{user.id}"
            }
          }
        )
      end

      context 'when user has some interests' do
        xit 'returnes user with his interests'
      end

      context "when user with given id doesn't exist in the DB" do
        it 'returns not found when user' do
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
    end

    context 'when user is unauthorized' do
      xit 'returns unauthorized'
    end
  end

  describe '#create' do
    context 'when user is authorized' do
      it 'creates new user' do
        create(:organization)

        expect do
          post :create, params: {
            data: {
              type: 'users',
              attributes: {
                first_name: 'Joe',
                last_name: 'Doe',
                email: 'joe.doe@example.com',
                age: 25,
                gender: 'male'
              }
            }
          }
        end.to change(User, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(response.body).to include_json(
          data: {
            type: 'users',
            attributes: {
              first_name: 'Joe',
              last_name: 'Doe',
              email: 'joe.doe@example.com',
              age: 25,
              gender: 'male'
            },
            links: {
              self: "http://test.host/admin/users/#{User.find_by(email: 'joe.doe@example.com').id}"
            }
          }
        )
        expect(User.find_by(email: 'joe.doe@example.com')).to have_attributes(
          first_name: 'Joe',
          last_name: 'Doe',
          email: 'joe.doe@example.com',
          age: 25,
          gender: 'male'
        )
      end
    end

    context 'when user is unauthorized' do
      xit 'returns unauthorized'
    end
  end

  describe '#update' do
    context 'when user is authorized' do
      it 'updates existing user' do
        user = create(
          :user,
          first_name: 'Joe',
          last_name: 'Doe',
          email: 'joe.doe@example.com',
          age: 50,
          gender: 'male'
        )

        patch :update, params: {
          id: user.id,
          data: {
            type: 'users',
            id: user.id,
            attributes: {
              first_name: 'Alice',
              last_name: 'Kowalski',
              email: 'alice.kowalski@example.com',
              age: 30,
              gender: 'female'
            }
          }
        }

        expect(response).to have_http_status(:ok)
        expect(response.body).to include_json(
          data: {
            type: 'users',
            id: user.id,
            attributes: {
              first_name: 'Alice',
              last_name: 'Kowalski',
              email: 'alice.kowalski@example.com',
              age: 30,
              gender: 'female'
            },
            links: {
              self: "http://test.host/admin/users/#{user.id}"
            }
          }
        )
        expect(user.reload).to have_attributes(
          first_name: 'Alice',
          last_name: 'Kowalski',
          email: 'alice.kowalski@example.com',
          age: 30,
          gender: 'female'
        )
      end

      context "when user with given id doesn't exist in the DB" do
        it 'returns not found ' do
          patch :update, params: {
            id: 1,
            data: {
              type: 'users',
              id: 1,
              attributes: {
                first_name: 'Alice',
                last_name: 'Kowalski',
                email: 'alice.kowalski@example.com',
                age: 30,
                gender: 'female'
              }
            }
          }

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
    end

    context 'when user is unauthorized' do
      xit 'returns unauthorized'
    end
  end
end
