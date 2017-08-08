require 'rails_helper'

RSpec.describe Admin::CategoriesController do
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
end
