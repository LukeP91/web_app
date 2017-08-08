require 'rails_helper'

describe 'Admin search' do
  context 'user with admin privileges' do
    scenario 'can search by email' do
      organization = create(:organization)
      admin = create(:admin, email: 'admin@example.com', organization: organization)
      create(:user, email: 'email@example.com', organization: organization)

      app = App.new
      app.home_page.load
      app.login_page.login(admin)
      expect(app.home_page).to be_displayed

      app.home_page.menu.admin_panel_link.click
      expect(app.admin_users_index_page).to be_displayed
      app.admin_users_index_page.search_field.set 'email@example.com'
      app.admin_users_index_page.search_button.click

      expect(app.admin_users_index_page.text).to include 'email@example.com'
      expect(app.admin_users_index_page.text).to_not include 'admin@example.com'
    end

    scenario 'can search by first name' do
      organization = create(:organization)
      admin = create(:admin, first_name: 'Luke', email: 'admin@example.com', organization: organization)
      create(:user, :male, :older_than_30, email: 'email@example.com', first_name: 'Jenny', organization: organization)

      app = App.new
      app.home_page.load
      app.login_page.login(admin)
      expect(app.home_page).to be_displayed

      app.home_page.menu.admin_panel_link.click
      expect(app.admin_users_index_page).to be_displayed
      app.admin_users_index_page.search_field.set 'Jenny'
      app.admin_users_index_page.search_button.click

      expect(app.admin_users_index_page.text).to include 'email@example.com'
      expect(app.admin_users_index_page.text).to_not include 'admin@example.com'
    end

    scenario 'can search by last name' do
      organization = create(:organization)
      admin = create(:admin, email: 'admin@example.com', last_name: 'Last Name', organization: organization)
      create(:user, :male, :older_than_30, email: 'email@example.com', last_name: 'Doe', organization: organization)

      app = App.new
      app.home_page.load
      app.login_page.login(admin)
      expect(app.home_page).to be_displayed

      app.home_page.menu.admin_panel_link.click
      expect(app.admin_users_index_page).to be_displayed
      app.admin_users_index_page.search_field.set 'Doe'
      app.admin_users_index_page.search_button.click

      expect(app.admin_users_index_page.text).to include 'email@example.com'
      expect(app.admin_users_index_page.text).to_not include 'admin@example.com'
    end

    scenario 'can search by age' do
      organization = create(:organization)
      admin = create(:admin, email: 'admin@example.com', age: 26, organization: organization)
      create(:user, :male, :older_than_30, email: 'email@example.com', age: 15, organization: organization)

      app = App.new
      app.home_page.load
      app.login_page.login(admin)
      expect(app.home_page).to be_displayed

      app.home_page.menu.admin_panel_link.click
      expect(app.admin_users_index_page).to be_displayed
      app.admin_users_index_page.search_field.set 15
      app.admin_users_index_page.search_button.click

      expect(app.admin_users_index_page.text).to include 'email@example.com'
      expect(app.admin_users_index_page.text).to_not include 'admin@example.com'
    end

    scenario 'can search by gender' do
      organization = create(:organization)
      admin = create(:admin, email: 'admin@example.com', organization: organization)
      user = create(:user, :male, :older_than_30, email: 'email@example.com', organization: organization)

      app = App.new
      app.home_page.load
      app.login_page.login(admin)
      expect(app.home_page).to be_displayed

      app.home_page.menu.admin_panel_link.click
      expect(app.admin_users_index_page).to be_displayed
      app.admin_users_index_page.search_field.set user.gender
      app.admin_users_index_page.search_button.click

      expect(app.admin_users_index_page.text).to include 'email@example.com'
      expect(app.admin_users_index_page.text).to_not include 'admin@example.com'
    end
  end
end
