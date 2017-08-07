require "rails_helper"

RSpec.describe Admin::UsersController, :type => :controller do
  include Devise::Test::ControllerHelpers
  render_views

  describe "GET #index" do
    it "allows to search users with postgres fts" do
      admin = create(:admin, first_name: 'Luke')
      user = create(:user, first_name: 'Pablo', organization: admin.organization)
      request.env["devise.mapping"] = Devise.mappings[:admin]
      sign_in admin
      get :index, params: { search: { search: 'Luke' } }
      expect(response.body).to include 'Luke'
      expect(response.body).to_not include 'Pablo'
    end
  end
end
