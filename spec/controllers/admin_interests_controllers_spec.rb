require 'rails_helper'

RSpec.describe Admin::InterestsController do
  include Devise::Test::ControllerHelpers

  describe '#index' do
    it 'redirects user without admin privileges to home page' do
      user = create(:user)
      request.env['devise.mapping'] = Devise.mappings[:admin]
      sign_in user

      get :index
      expect(response).to redirect_to(root_path)
    end
  end

  describe '#show' do
    it 'redirects user without admin privileges to home page' do
      organization = create(:organization)
      user = create(:user, organization: organization)
      interest = create(:interest, organization: organization)
      request.env['devise.mapping'] = Devise.mappings[:admin]
      sign_in user

      get :show, params: { id: interest.id }
      expect(response).to redirect_to(root_path)
    end

    it 'redirects admin when accessing interest outside his organization' do
      organization = create(:organization)
      user = create(:admin, organization: organization)
      interest = create(:interest)
      request.env['devise.mapping'] = Devise.mappings[:admin]
      sign_in user

      get :show, params: { id: interest.id }
      expect(response).to redirect_to(admin_interests_path)
    end
  end
end
