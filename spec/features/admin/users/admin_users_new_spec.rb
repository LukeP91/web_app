require 'rails_helper'

describe 'Admin new' do
  context 'User with admin priviliges' do
    scenario 'can add new users to his organization' do
      organization = create(:organization)
      admin = create(:admin, organization: organization)
      create(:interest, name: 'test1')
      new_user = { first_name: 'New', last_name: 'User', email: 'new_user_email@example.com', gender: 'male', age: '15' }

      app = App.new
      app.home_page.load
      app.login_page.login(admin)
      expect(app.home_page).to be_displayed

      app.home_page.menu.admin_panel_link.click
      expect(app.admin_users_index_page).to be_displayed

      app.admin_users_index_page.create_user_button.click
      app.admin_users_new_page.form.fill(new_user)
      app.admin_users_new_page.form.interests_field.select 'test1'
      app.admin_users_new_page.form.confirm_button.click

      expect(app.admin_users_show_page).to be_displayed
      expect(app.admin_users_show_page.text).to include "#{new_user[:first_name]} #{new_user[:last_name]}"
      expect(app.admin_users_show_page.text).to include new_user[:email]
      expect(app.admin_users_show_page.text).to include new_user[:first_name]
      expect(app.admin_users_show_page.text).to include new_user[:last_name]
      expect(app.admin_users_show_page.text).to include new_user[:gender]
      expect(app.admin_users_show_page.text).to include new_user[:age]
      expect(app.admin_users_show_page.text).to include 'test1'
    end

    scenario 'create empty user should rerender new page' do
      admin = create(:admin)

      app = App.new
      app.home_page.load
      app.login_page.login(admin)
      expect(app.home_page).to be_displayed

      app.home_page.menu.admin_panel_link.click
      expect(app.admin_users_index_page).to be_displayed

      app.admin_users_index_page.create_user_button.click
      app.admin_users_new_page.form.confirm_button.click
      expect(app.admin_users_index_page).to be_displayed
      expect(app.admin_users_index_page.text).to include 'New User'
    end
  end

  context 'User without admin privileges' do
    scenario "can't add new users" do
      user = create(:user)

      app = App.new
      app.home_page.load
      app.login_page.login(user)
      expect(app.home_page).to be_displayed

      app.admin_users_new_page.load
      expect(app.home_page).to be_displayed
    end
  end
end
