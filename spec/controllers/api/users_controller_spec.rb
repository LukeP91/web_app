require 'rails_helper'

describe Api::UsersController do
  include ActiveJob::TestHelper

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
                self: "http://test.host/api/users/#{joe.id}"
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
                self: "http://test.host/api/users/#{alice.id}"
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
            self: 'http://test.host/api/users',
            first: 'http://test.host/api/users?page=1&per_page=1',
            prev: 'http://test.host/api/users?page=2&per_page=1',
            next: 'http://test.host/api/users?page=4&per_page=1',
            last: 'http://test.host/api/users?page=5&per_page=1'
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
                self: "http://test.host/api/users/#{alice.id}"
              }
            }
          ]
        )
      end

      describe 'links section' do
        context 'where there is only one page' do
          it 'returns only self' do
            get :index

            expect(json_response.fetch('links')).to eq('self' => 'http://test.host/api/users')
          end
        end

        context 'when currently on first page' do
          it "doesn't return link to first page" do
            create_list(:user, 2)

            get :index, params: { page: 1, per_page: 1 }

            expect(json_response.fetch('links')).to_not have_key('first')
          end

          it "doesn't return link to previous page" do
            create_list(:user, 2)

            get :index, params: { page: 1, per_page: 1 }

            expect(json_response.fetch('links')).to_not have_key('prev')
          end
        end

        context 'when currently on last page' do
          it "doesn't return link to next page" do
            create_list(:user, 2)

            get :index, params: { page: 2, per_page: 1 }

            expect(json_response.fetch('links')).to_not have_key('next')
          end

          it "doesn't return link to last page" do
            create_list(:user, 2)

            get :index, params: { page: 2, per_page: 1 }

            expect(json_response.fetch('links')).to_not have_key('last')
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
              self: "http://test.host/api/users/#{user.id}"
            }
          }
        )
      end

      context 'when user has some interests' do
        it 'returnes user with his interests' do
          category = create(:category, name: 'hobby')
          book_reading = create(:interest, name: 'Book Reading', category: category)
          swimming = create(:interest, name: 'Swimming', category: category)
          user = create(
            :user,
            first_name: 'Joe',
            last_name: 'Doe',
            email: 'joe.doe@example.com',
            age: 50,
            gender: 'male',
            interests: [book_reading, swimming]
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
              relationships: {
                interests: {
                  links:{
                    self: "http://test.host/api/users/#{user.id}/interests",
                    related: "http://test.host/api/users/#{user.id}/interests"
                  },
                  data: [
                    { type: 'interests', id: book_reading.id, data: { name: 'Book Reading', category: 'hobby'}},
                    { type: 'interests', id: swimming.id, data: { name: 'Swimming', category: 'hobby'}}
                  ]
                }
              },
              links: {
                self: "http://test.host/api/users/#{user.id}"
              }
            }
          )
        end
      end

      context 'when user has no interests' do
        it 'returns response without relationships node' do
          user = create(:user)

          get :show, params: { id: user.id }

          expect(json_response.fetch('data')).to_not have_key('relationships')
        end
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
      context 'when user data is valid' do
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
          end.to change { User.count }.by(1)

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
                self: "http://test.host/api/users/#{User.find_by(email: 'joe.doe@example.com').id}"
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

        it 'sends reset password email to created user' do
          create(:organization)

          expect_any_instance_of(User).to receive(:send_reset_password_instructions)

          post :create, params: {
            data: {
              type: 'users',
              attributes: {
                first_name: 'Joe',
                last_name: 'Doe',
                email: 'joe.doe@example.com'
              }
            }
          }
        end
      end

      context 'when user data is invalid' do
        it 'returns validation errors' do
          post :create, params: {
            data: {
              type: 'users',
              attributes: {
                first_name: '',
                last_name: 'Doe',
                email: 'joe.doe@example.com'
              }
            }
          }

          expect(response).to have_http_status(:bad_request)
          expect(response.body).to include_json(
            errors: {
              first_name: ["can't be blank"]
            }
          )
        end

        it 'does not create new user' do
          expect do
            post :create, params: {
              data: {
                type: 'users',
                attributes: {
                  first_name: '',
                  last_name: 'Doe',
                  email: 'joe.doe@example.com'
                }
              }
            }
          end.to_not change { User.count }
        end
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
              self: "http://test.host/api/users/#{user.id}"
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

      it 'does not allow to change password' do
        user = create(
          :user,
          first_name: 'Joe',
          last_name: 'Doe',
          email: 'joe.doe@example.com'
        )

        expect do
          patch :update, params: {
            id: user.id,
            data: {
              type: 'users',
              attributes: {
                password: 'uber_password',
                password_confirmation: 'uber_password'
              }
            }
          }
        end.to_not change { user.reload.encrypted_password }
      end

      context 'when user data is invalid' do
        it 'returns validation errors when user data is invalid' do
          user = create(
            :user,
            first_name: 'Joe',
            last_name: 'Doe',
            email: 'joe.doe@example.com'
          )

          patch :update, params: {
            id: user.id,
            data: {
              type: 'users',
              attributes: {
                first_name: '',
                last_name: 'Kowalski',
                email: 'changed@example.com'
              }
            }
          }

          expect(response).to have_http_status(:bad_request)
          expect(response.body).to include_json(
            errors: {
              first_name: ["can't be blank"]
            }
          )
        end

        it 'does not update user attirbutes' do
          user = create(
            :user,
            first_name: 'Joe',
            last_name: 'Doe',
            email: 'joe.doe@example.com'
          )

          patch :update, params: {
            id: user.id,
            data: {
              type: 'users',
              attributes: {
                first_name: '',
                last_name: 'Kowalski',
                email: 'changed@example.com'
              }
            }
          }

          expect(user.reload).to have_attributes(
            first_name: 'Joe',
            last_name: 'Doe',
            email: 'joe.doe@example.com'
          )
        end
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

  describe '#destroy' do
    context 'when user is authorized' do
      it 'destroys user' do
        user = create(:user)

        expect do
          delete :destroy, params: { id: user.id }
        end.to change { User.count }.by(-1)
        expect(response).to have_http_status(:no_content)
      end

      context 'when user does not exist in DB' do
        it 'returns not found when user does not exist id DB' do
          delete :destroy, params: { id: 1 }
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

    context 'when user is not authorized' do
      xit 'it does not allow to delete user'
    end
  end
end
