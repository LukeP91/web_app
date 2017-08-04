require 'rails_helper'

describe 'Admin new', type: :feature do
  context 'User with admin priviliges' do
    let(:organization) { create(:organization) }
    let(:admin) { create(:admin, organization: organization) }
    let(:user) { build(:user, :female, :younger_than_20) }

    scenario 'can add new users to his organization' do
      create(:interest, name: 'test1')

      app = App.new
      app.home_page.load
      app.login_page.login(admin)
      expect(app.home_page).to be_displayed

      app.home_page.menu.admin_panel_link.click
      expect(app.admin_users_index_page).to be_displayed


      app.admin_users_index_page.create_user_button.click
      app.admin_users_new_page.form.email_field.set user.email
      app.admin_users_new_page.form.first_name_field.set user.first_name
      app.admin_users_new_page.form.last_name_field.set user.last_name
      app.admin_users_new_page.form.gender_field.select user.gender
      app.admin_users_new_page.form.age_field.select user.age
      # app.admin_users_new_page.form.interests_field.select 'test1'

      app.admin_users_new_page.form.confirm_button.click

      expect(app.admin_users_show_page).to be_displayed
      expect(app.admin_users_show_page.text).to include user.full_name
      expect(app.admin_users_show_page.text).to include user.email
      expect(app.admin_users_show_page.text).to include user.first_name
      expect(app.admin_users_show_page.text).to include user.last_name
      expect(app.admin_users_show_page.text).to include user.gender
      expect(app.admin_users_show_page.text).to include user.age.to_s
      # expect(app.admin_users_show_page.text).to include 'test1'
    end
  end

  context 'User without admin privileges' do
    let(:user) { create(:user) }

    scenario "can't add new users" do
      app = App.new
      app.home_page.load
      app.login_page.login(user)
      expect(app.home_page).to be_displayed

      app.admin_users_new_page.load
      expect(app.home_page).to be_displayed
    end
  end
end
