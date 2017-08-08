require 'rails_helper'

describe 'Admin edit' do
  context 'User with admin priviliges' do
    scenario 'can edit users from his organization' do
      organization = create(:organization)
      admin = create(:admin, organization: organization)
      create(:interest, name: 'test1')
      user = create(:user, :male, :older_than_30, organization: organization)
      edited_user = { first_name: 'New', last_name: 'User', email: 'new_user_email@example.com', gender: 'male', age: '15'}

      app = App.new
      app.home_page.load
      app.login_page.login(admin)
      expect(app.home_page).to be_displayed

      app.home_page.menu.admin_panel_link.click
      expect(app.admin_users_index_page).to be_displayed

      app.admin_users_index_page.edit_button(user.id).click
      app.admin_users_edit_page.form.fill(edited_user)
      app.admin_users_edit_page.form.interests_field.select 'test1'
      app.admin_users_edit_page.form.confirm_button.click

      expect(app.admin_users_show_page).to be_displayed
      expect(app.admin_users_show_page.text).to include "#{edited_user[:first_name]} #{edited_user[:last_name]}"
      expect(app.admin_users_show_page.text).to include edited_user[:email]
      expect(app.admin_users_show_page.text).to include edited_user[:first_name]
      expect(app.admin_users_show_page.text).to include edited_user[:last_name]
      expect(app.admin_users_show_page.text).to include edited_user[:gender]
      expect(app.admin_users_show_page.text).to include edited_user[:age]
      expect(app.admin_users_show_page.text).to include 'test1'
    end

    scenario "can't edit users outside his organization" do
      organization = create(:organization)
      admin = create(:admin, organization: organization)
      user = create(:user)

      app = App.new
      app.home_page.load
      app.login_page.login(admin)
      expect(app.home_page).to be_displayed

      app.home_page.menu.admin_panel_link.click
      expect(app.admin_users_index_page).to be_displayed

      expect(page).to_not have_css "user_edit_#{user.id}"
      app.admin_users_edit_page.load(id: user.id)
      expect(app.admin_users_index_page).to be_displayed
    end
  end

  context 'User without admin privileges' do
    scenario "can't edit other users" do
      user = create(:user)
      app = App.new
      app.home_page.load
      app.login_page.login(user)
      expect(app.home_page).to be_displayed

      app.admin_users_edit_page.load(id: user.id)
      expect(app.home_page).to be_displayed
    end
  end
end
