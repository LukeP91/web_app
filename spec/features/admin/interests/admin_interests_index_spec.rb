require 'rails_helper'

describe 'Admin interests index' do
  context 'user with admin privileges' do
    scenario 'can access interests index with only interests from his organization' do
      organization = create(:organization)
      admin = create(:admin, organization: organization)
      create(:interest, name: 'Golfing', organization: organization)
      create(:interest, name: 'Running')

      app = App.new
      app.home_page.load
      app.login_page.login(admin)
      expect(app.home_page).to be_displayed

      app.home_page.menu.admin_interests_link.click
      expect(app.admin_interests_index_page).to be_displayed
      expect(app.admin_interests_index_page.text).to include 'Golfing'
      expect(app.admin_interests_index_page.text).to_not include 'Running'
    end
  end
end
