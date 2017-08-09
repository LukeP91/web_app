require 'rails_helper'

describe 'Admin new' do
  context 'User with admin priviliges' do
    scenario 'can add new users to his organization' do
      organization = create(:organization)
      admin = create(:admin, organization: organization)
      create(:interest, name: 'Reading')

      app = App.new
      app.home_page.load
      app.login_page.login(admin)
      expect(app.home_page).to be_displayed

      app.home_page.menu.admin_panel_link.click
      expect(app.admin_users_index_page).to be_displayed

      app.admin_users_index_page.create_user_button.click
      app.admin_users_new_page.form.email_field.set 'john_doe@example.com'
      app.admin_users_new_page.form.first_name_field.set 'John'
      app.admin_users_new_page.form.last_name_field.set 'Doe'
      app.admin_users_new_page.form.gender_field.select 'male'
      app.admin_users_new_page.form.age_field.select '35'
      app.admin_users_new_page.form.interests_field.select 'Reading'
      app.admin_users_new_page.form.confirm_button.click

      expect(app.admin_users_show_page).to be_displayed
      expect(app.admin_users_show_page.full_name_field.text).to eq 'John Doe'
      expect(app.admin_users_show_page.field_by_label('Email').text).to eq 'Email: john_doe@example.com'
      expect(app.admin_users_show_page.field_by_label('First name').text).to eq 'First name: John'
      expect(app.admin_users_show_page.field_by_label('Last name').text).to eq 'Last name: Doe'
      expect(app.admin_users_show_page.field_by_label('Gender').text).to eq 'Gender: male'
      expect(app.admin_users_show_page.field_by_label('Age').text).to eq 'Age: 35'
      expect(app.admin_users_show_page.text).to include 'Reading'
    end
  end
end
