require 'rails_helper'

describe 'Admin edit' do
  context 'User with admin priviliges' do
    scenario 'can edit users from his organization' do
      organization = create(:organization)
      admin = create(:admin, organization: organization)
      create(:interest, name: 'Reading')
      user = create(:user, :female, :older_than_30, organization: organization)

      app = App.new
      app.home_page.load
      app.login_page.login(admin)
      expect(app.home_page).to be_displayed

      app.home_page.menu.admin_panel_link.click
      expect(app.admin_users_index_page).to be_displayed

      app.admin_users_index_page.edit_button(user.id).click
      app.admin_users_edit_page.form.email_field.set 'john_doe@example.com'
      app.admin_users_edit_page.form.first_name_field.set 'John'
      app.admin_users_edit_page.form.last_name_field.set 'Doe'
      app.admin_users_edit_page.form.gender_field.select 'male'
      app.admin_users_edit_page.form.age_field.select '35'
      app.admin_users_edit_page.form.interests_field.select 'Reading'
      app.admin_users_edit_page.form.confirm_button.click

      expect(app.admin_users_show_page).to be_displayed
      expect(app.admin_users_show_page.full_name_field.text).to eq 'John Doe'
      expect(app.admin_users_show_page.field_by_label('Email').text).to eq 'Email: john_doe@example.com'
      expect(app.admin_users_show_page.field_by_label('First name').text).to eq 'First name: John'
      expect(app.admin_users_show_page.field_by_label('Last name').text).to eq 'Last name: Doe'
      expect(app.admin_users_show_page.field_by_label('Gender').text).to eq 'Gender: male'
      expect(app.admin_users_show_page.field_by_label('Age').text).to eq 'Age: 35'
      expect(app.admin_users_show_page.text).to include 'Reading'
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
