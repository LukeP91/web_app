require 'rails_helper'

describe Auth::FacebooksController do
  include Devise::Test::ControllerHelpers

  describe '#show' do
    it 'redirects user without admin privileges to home page' do
      user = create(:user)
      request.env['devise.mapping'] = Devise.mappings[:admin]
      sign_in user

      get :show

      expect(response).to redirect_to(root_path)
    end
  end
end
