require 'rails_helper'

describe 'Admin show' do
  context 'User with admin privileges' do
    scenario 'can see users profiles from his organization' do
      organization = create(:organization)
      admin = create(:admin, organization: organization)
      user = create(:user_with_interests, email: 'john.doe@example.com', first_name: 'John', last_name: 'Doe', age: 25, gender: 'male', organization: organization)

      app = App.new
      app.home_page.load
      app.login_page.login(admin)
      expect(app.home_page).to be_displayed

      app.home_page.menu.admin_panel_link.click
      expect(app.admin_users_index_page).to be_displayed

      app.admin_users_index_page.show_button(user.id).click
      expect(app.admin_users_show_page).to be_displayed
      expect(app.admin_users_show_page.text).to include 'John Doe'
      expect(app.admin_users_show_page.text).to include 'john.doe@example.com'
      expect(app.admin_users_show_page.text).to include 'John'
      expect(app.admin_users_show_page.text).to include 'Doe'
      expect(app.admin_users_show_page.text).to include 'male'
      expect(app.admin_users_show_page.text).to include '25'
    end

    scenario "can't see users profiles outside his organization" do
      organization = create(:organization)
      admin = create(:admin, organization: organization)
      user = create(:user_with_interests, :male, :older_than_30)

      app = App.new
      app.home_page.load
      app.login_page.login(admin)
      expect(app.home_page).to be_displayed

      app.home_page.menu.admin_panel_link.click
      expect(app.admin_users_index_page).to be_displayed

      expect(page).to_not have_xpath "user_show_#{user.id}"
      app.admin_users_show_page.load(id: user.id)
      expect(app.admin_users_index_page).to be_displayed
    end
  end

  context 'User without admin privileges' do
    scenario "can't see other users profiles" do
      user = create(:user)

      app = App.new
      app.home_page.load
      app.login_page.login(user)
      expect(app.home_page).to be_displayed

      app.admin_users_show_page.load(id: user.id)
      expect(app.home_page).to be_displayed
    end
  end
end
