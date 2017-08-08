require 'rails_helper'

describe 'Admin edit' do
  context 'User with admin priviliges' do
    before do
      @organization = create(:organization)
      @admin = create(:admin, organization: @organization)
    end

    scenario 'can edit users from his organization' do
      create(:interest, name: 'test1')
      user = create(:user, :male, :older_than_30, organization: @organization)
      modified_user = {
        email: 'changed_email@example.com',
        first_name: 'Modified',
        last_name: 'Modified',
        gender: 'female',
        age: 15
      }

      app = App.new
      app.home_page.load
      app.login_page.login(@admin)
      expect(app.home_page).to be_displayed

      app.home_page.menu.admin_panel_link.click
      expect(app.admin_users_index_page).to be_displayed

      app.admin_users_index_page.edit_button(user.id).click
      app.admin_users_edit_page.form.email_field.set modified_user[:email]
      app.admin_users_edit_page.form.first_name_field.set modified_user[:first_name]
      app.admin_users_edit_page.form.last_name_field.set modified_user[:last_name]
      app.admin_users_edit_page.form.gender_field.select modified_user[:gender]
      app.admin_users_edit_page.form.age_field.select modified_user[:age]
      app.admin_users_edit_page.form.interests_field.select 'test1'
      app.admin_users_edit_page.form.confirm_button.click

      expect(app.admin_users_show_page).to be_displayed
      expect(app.admin_users_show_page.text).to include "#{modified_user[:first_name]} #{modified_user[:last_name]}"
      expect(app.admin_users_show_page.text).to include modified_user[:email]
      expect(app.admin_users_show_page.text).to include modified_user[:first_name]
      expect(app.admin_users_show_page.text).to include modified_user[:last_name]
      expect(app.admin_users_show_page.text).to include modified_user[:gender]
      expect(app.admin_users_show_page.text).to include modified_user[:age].to_s
      expect(app.admin_users_show_page.text).to include 'test1'
    end

    scenario "can't edit users outside his organization" do
      user = create(:user, :male, :older_than_30)

      app = App.new
      app.home_page.load
      app.login_page.login(@admin)
      expect(app.home_page).to be_displayed

      app.home_page.menu.admin_panel_link.click
      expect(app.admin_users_index_page).to be_displayed

      expect(page).to_not have_css "user_edit_#{user.id}"
      app.admin_users_edit_page.load(id: user.id)
      expect(app.admin_users_index_page).to be_displayed
    end
  end

  context 'User without admin privileges' do
    before do
      @user = create(:user)
    end

    scenario "can't edit other users" do
      app = App.new
      app.home_page.load
      app.login_page.login(@user)
      expect(app.home_page).to be_displayed

      app.admin_users_edit_page.load(id: @user.id)
      expect(app.home_page).to be_displayed
    end
  end
end
