require 'rails_helper'

describe 'Admin Twitter statistics show' do
  context 'user with admin privileges' do
    scenario 'can access statistics for Twitter from his organization' do
      organization = create(:organization)
      admin = create(:admin, first_name: 'Luke', last_name: 'Admin', organization: organization)

      app = App.new
      app.home_page.load
      app.login_page.login(admin)
      expect(app.home_page).to be_displayed

      app.home_page.menu.admin_statistics_link.click
      expect(app.admin_statistics_show_page).to be_displayed
    end
  end
end
