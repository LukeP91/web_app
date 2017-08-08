require "rails_helper"

RSpec.describe Admin::UsersController do
  include Devise::Test::ControllerHelpers
  render_views

  describe "#index" do
    it 'redirects user without admin privileges to home page' do
      user = create(:user)
      request.env['devise.mapping'] = Devise.mappings[:admin]
      sign_in user

      get :index
      expect(response).to redirect_to(root_path)
    end

    it "allows to search users with postgres fts" do
      admin = create(:admin, first_name: 'Luke')
      user = create(:user, first_name: 'Pablo', organization: admin.organization)
      request.env["devise.mapping"] = Devise.mappings[:admin]
      sign_in admin

      get :index, params: { search: { text: admin.first_name } }
      expect(response.body).to include admin.first_name
      expect(response.body).to_not include user.first_name
    end
  end

  describe '#show' do
    it 'redirects user without admin privileges to home page' do
      organization = create(:organization)
      user = create(:user, organization: organization)
      request.env['devise.mapping'] = Devise.mappings[:admin]
      sign_in user

      get :show, params: { id: user.id }
      expect(response).to redirect_to(root_path)
    end

    it 'redirects admin when accessing interest outside his organization' do
      organization = create(:organization)
      admin = create(:admin, organization: organization)
      user = create(:user)
      request.env['devise.mapping'] = Devise.mappings[:admin]
      sign_in admin

      get :show, params: { id: user.id }
      expect(response).to redirect_to(admin_users_path)
    end
  end

  describe '#new' do
    it 'redirects user without admin privileges to home page' do
      organization = create(:organization)
      user = create(:user, organization: organization)
      request.env['devise.mapping'] = Devise.mappings[:admin]
      sign_in user

      get :new
      expect(response).to redirect_to(root_path)
    end
  end

  describe '#edit' do
    it 'redirects user without admin privileges to home page' do
      organization = create(:organization)
      user = create(:user, organization: organization)
      request.env['devise.mapping'] = Devise.mappings[:admin]
      sign_in user

      get :edit, params: { id: user.id }
      expect(response).to redirect_to(root_path)
    end
  end

  describe '#delete' do
    it 'redirects user without admin privileges to home page' do
      organization = create(:organization)
      user = create(:user, organization: organization)
      user_to_delete = create(:user, organization: organization)
      request.env['devise.mapping'] = Devise.mappings[:admin]
      sign_in user

      delete :destroy, params: { id: user_to_delete.id }
      expect(response).to redirect_to(root_path)
    end
  end

  describe '#send_email' do
    it 'redirects user without admin privileges to home page' do
      organization = create(:organization)
      user = create(:user, organization: organization)
      request.env['devise.mapping'] = Devise.mappings[:admin]
      sign_in user

      expect(LannisterMailer).to_not(receive(:regards_email).with(user, user))
      get :send_email, params: { id: user.id }
      expect(response).to redirect_to(root_path)
    end
  end
end
