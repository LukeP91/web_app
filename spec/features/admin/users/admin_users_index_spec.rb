require 'rails_helper'

describe 'Admin listing' do
  context 'user with admin privileges' do
    scenario 'can access dashboard' do
      admin = create(:admin)

      app = App.new
      app.home_page.load
      app.login_page.login(admin)
      expect(app.home_page).to be_displayed

      app.home_page.menu.admin_panel_link.click
      expect(app.admin_users_index_page).to be_displayed
    end

    scenario 'can see only users from his organization' do
      organization = create(:organization)
      admin = create(:admin, first_name: 'Luke', last_name: 'Admin', organization: organization)
      create(:user, first_name: 'Pablo', last_name: 'User', organization: organization)
      create(:user, first_name: 'Alice', last_name: 'Wonderland')

      app = App.new
      app.home_page.load
      app.login_page.login(admin)
      expect(app.home_page).to be_displayed

      app.home_page.menu.admin_panel_link.click
      expect(app.admin_users_index_page).to be_displayed
      expect(app.admin_users_index_page.text).to include 'Luke Admin'
      expect(app.admin_users_index_page.text).to include 'Pablo User'
      expect(app.admin_users_index_page.text).to_not include 'Alice Wonderland'
    end
  end

  context 'user without admin privileges' do
    scenario "can't access dashboard" do
      user = create(:user)
      app = App.new
      app.home_page.load
      app.login_page.login(user)
      expect(app.home_page).to be_displayed

      expect(app.home_page.menu).to have_no_admin_panel_link
      app.admin_users_index_page.load
      expect(app.home_page).to be_displayed
    end
  end
end
