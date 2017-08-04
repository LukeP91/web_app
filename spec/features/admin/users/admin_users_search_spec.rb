require 'rails_helper'

describe 'Admin search', type: :feature do
  context 'user with admin privileges' do
    before do
      organization = create(:organization)
      @admin = create(:admin, :female, :between_20_and_30, organization: organization)
      @user = create(:user, :male, :older_than_30, email: 'email@example.com', organization: organization)
    end

    scenario 'can search by email' do
      app = App.new
      app.home_page.load
      app.login_page.login(@admin)
      expect(app.home_page).to be_displayed

      app.home_page.menu.admin_panel_link.click
      expect(app.admin_users_index_page).to be_displayed
      app.admin_users_index_page.search_field.set @user.email
      app.admin_users_index_page.search_button.click

      expect(app.admin_users_index_page.text).to include @user.email
      expect(app.admin_users_index_page.text).to_not include @admin.email
    end

    xscenario 'can search by first name' do
      app = App.new
      app.home_page.load
      app.login_page.login(@admin)
      expect(app.home_page).to be_displayed

      app.home_page.menu.admin_panel_link.click
      expect(app.admin_users_index_page).to be_displayed
      app.admin_users_index_page.search_field.set @user.first_name
      app.admin_users_index_page.search_button.click

      expect(app.admin_users_index_page.text).to include @user.email
      expect(app.admin_users_index_page.text).to_not include @admin.email
    end

    xscenario 'can search by last name' do
      app = App.new
      app.home_page.load
      app.login_page.login(@admin)
      expect(app.home_page).to be_displayed

      app.home_page.menu.admin_panel_link.click
      expect(app.admin_users_index_page).to be_displayed
      app.admin_users_index_page.search_field.set @user.last_name
      app.admin_users_index_page.search_button.click

      expect(app.admin_users_index_page.text).to include @user.email
      expect(app.admin_users_index_page.text).to_not include @admin.email
    end

    xscenario 'can search by age' do
      app = App.new
      app.home_page.load
      app.login_page.login(@admin)
      expect(app.home_page).to be_displayed

      app.home_page.menu.admin_panel_link.click
      expect(app.admin_users_index_page).to be_displayed
      app.admin_users_index_page.search_field.set @user.age
      app.admin_users_index_page.search_button.click

      expect(app.admin_users_index_page.text).to include @user.email
      expect(app.admin_users_index_page.text).to_not include @admin.email
    end

    xscenario 'can search by gender' do
      app = App.new
      app.home_page.load
      app.login_page.login(@admin)
      expect(app.home_page).to be_displayed

      app.home_page.menu.admin_panel_link.click
      expect(app.admin_users_index_page).to be_displayed
      app.admin_users_index_page.search_field.set @user.gender
      app.admin_users_index_page.search_button.click

      expect(app.admin_users_index_page.text).to include @user.email
      expect(app.admin_users_index_page.text).to_not include @admin.email
    end

    xscenario 'search only displayes users from his organization' do
      user = create(:user, :male, :older_than_30)
      app = App.new
      app.home_page.load
      app.login_page.login(@admin)
      expect(app.home_page).to be_displayed

      app.home_page.menu.admin_panel_link.click
      expect(app.admin_users_index_page).to be_displayed
      app.admin_users_index_page.search_field.set user.email
      app.admin_users_index_page.search_button.click

      expect(app.admin_users_index_page.text).to_not include user.email
    end
  end

  context 'user without admin privileges' do
    let(:user) { create(:user_with_interests, :male, :older_than_30) }

    scenario "can't search users" do
      app = App.new
      app.home_page.load
      app.login_page.login(user)
      expect(app.home_page).to be_displayed

      expect(app.home_page.menu).to have_no_admin_panel_link
      app.admin_users_index_page.load(query: { utf8: '✓', email_cont: user.email })
      expect(app.home_page).to be_displayed
    end
  end
end
