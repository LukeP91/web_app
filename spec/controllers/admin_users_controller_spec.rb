require 'rails_helper'

RSpec.describe Admin::UsersController do
  include Devise::Test::ControllerHelpers
  include EmailSpec::Helpers
  include EmailSpec::Matchers
  include ActiveJob::TestHelper
  render_views
  before { request.env['devise.mapping'] = Devise.mappings[:admin] }

  describe '#index' do
    context 'admin is signed in' do
      it 'returns paginated users' do
        admin = create(:admin, first_name: 'Luke')
        create_list(:user, 40, organization: admin.organization)
        sign_in admin

        get :index, params: { page: 1 }

        expect(response.body).to have_css('.user_row', count: 30)
      end

      it 'allows to search users' do
        admin = create(:admin, first_name: 'Luke')
        user = create(:user, first_name: 'Pablo', organization: admin.organization)
        sign_in admin

        allow(controller).to receive(:render)
        get :index, params: { search: { text: admin.first_name } }

        expect(controller).to have_received(:render)
          .with(:index, locals: { users: include(have_attributes(first_name: 'Luke')) })
        expect(controller).to_not have_received(:render)
          .with(:index, locals: { users: include(have_attributes(first_name: 'Pablo')) })
      end
    end

    context 'admin is not signed in' do
      it 'redirects user without admin privileges to home page' do
        user = create(:user)
        sign_in user

        get :index

        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe '#show' do
    context 'admin is signed in' do
      it 'redirects admin when accessing interest outside his organization' do
        organization = create(:organization)
        admin = create(:admin, organization: organization)
        user = create(:user)
        sign_in admin

        get :show, params: { id: user.id }

        expect(response).to redirect_to(admin_users_path)
      end
    end

    context 'admin is not signed in' do
      it 'redirects user without admin privileges to home page' do
        user = create(:user)
        sign_in user

        get :show, params: { id: user.id }

        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe '#new' do
    context 'admin is not signed in' do
      it 'redirects user without admin privileges to home page' do
        user = create(:user)
        sign_in user

        get :new

        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe '#create' do
    context 'admin is signed in' do
      it 'rerender new page when empty user is provided' do
        admin = create(:admin)
        sign_in admin

        post :create, params: { user: { email: '', first_name: '', last_name: '', password: '', password_confirmation: '', admin: 'false' } }

        expect(response).to render_template :new
      end
    end

    context 'admin is not signed in' do
      it 'redirects user without admin privileges to home page' do
        user = create(:user)
        sign_in user

        post :create, params: { user: { email: '', first_name: '', last_name: '', password: '', password_confirmation: '', admin: 'false' } }

        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe '#edit' do
    context 'admin is signed in' do
      it "does not allow to edit users outside his organization" do
        organization = create(:organization)
        admin = create(:admin, organization: organization)
        user = create(:user)
        sign_in admin

        get :edit, params: { id: user.id }

        expect(response).to redirect_to(admin_users_path)
      end
    end

    context 'admin is not signed in' do
      it 'redirects user without admin privileges to home page' do
        user = create(:user)
        sign_in user

        get :edit, params: { id: user.id }

        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe '#delete' do
    context 'admin is signed in' do
      it "does not allow to delete himself" do
        admin = create(:admin)
        sign_in admin

        delete :destroy, params: { id: admin.id }

        expect(response).to redirect_to(root_path)
        expect(User.count).to eq 1
      end

      it "does not allow to delete users outside his organization" do
        admin = create(:admin)
        user = create(:user)
        sign_in admin

        delete :destroy, params: { id: user.id }

        expect(response).to redirect_to(admin_users_path)
        expect(User.count).to eq 2
      end
    end

    context 'admin is not signed in' do
      it 'redirects user without admin privileges to home page' do
        organization = create(:organization)
        user = create(:user, organization: organization)
        user_to_delete = create(:user, organization: organization)
        sign_in user

        delete :destroy, params: { id: user_to_delete.id }

        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe '#send_email' do
    context 'admin is signed in' do
      it "does not allow to send regards email to users outside his organization" do
        organization = create(:organization)
        admin = create(:admin, organization: organization)
        user = create(:user)
        sign_in admin

        expect(LannisterMailer).to_not(receive(:regards_email).with(user, user))
        get :send_email, params: { id: user.id }, xhr: true

        expect(response).to redirect_to(admin_users_path)
      end
    end

    context 'admin is not signed in' do
      it 'redirects user without admin privileges to home page' do
        user = create(:user)
        sign_in user

        expect(LannisterMailer).to_not(receive(:regards_email).with(user, user))
        get :send_email, params: { id: user.id }, xhr: true

        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe '#welcome_email' do
    context 'admin is signed in' do
      it "send email to all users in organization" do
        organization = create(:organization)
        admin = create(:admin, email: 'admin@example.com', organization: organization)
        joe = create(:user, email: 'joe.doe@example.com', organization: organization)
        alice = create(:user, email: 'alice.doe@example.com')
        sign_in admin

        perform_enqueued_jobs do
          get :welcome_email, xhr: true

          mails = ActionMailer::Base.deliveries
          expect(mails.count).to eq 2
          expect(mails.map(&:to).flatten).to match_array ['joe.doe@example.com', 'admin@example.com']
          expect(mails.map(&:to).flatten).to_not match_array ['alice.doe@example.com']
          expect(mails.map(&:subject)).to contain_exactly("Welcome!", "Welcome!")
        end
      end
    end

    context 'admin is not signed in' do
      it 'redirects user without admin privileges to home page' do
        user = create(:user)
        sign_in user

        perform_enqueued_jobs do
          get :welcome_email, xhr: true

          mails = ActionMailer::Base.deliveries
          expect(mails.count).to eq 0
          expect(response).to redirect_to(root_path)
        end
      end
    end
  end
end
