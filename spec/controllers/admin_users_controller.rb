require "rails_helper"

RSpec.describe Admin::UsersController do
  include Devise::Test::ControllerHelpers
  render_views

  describe "#index" do
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
end
