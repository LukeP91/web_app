require 'rails_helper'

describe 'Edit profile' do
  context 'signed in user' do
    scenario 'can edit his profile' do
      user = create(:user, :male, :older_than_30)

      app = App.new
      app.home_page.load
      app.login_page.login(user)

      app.home_page.edit_button.click
      expect(app.edit_profile_page).to be_displayed

      app.edit_profile_page.form.email_field.set 'john_doe@example.com'
      app.edit_profile_page.form.first_name_field.set 'John'
      app.edit_profile_page.form.last_name_field.set 'Doe'
      app.edit_profile_page.form.gender_field.select 'male'
      app.edit_profile_page.form.age_field.select '25'
      app.edit_profile_page.form.confirm_button.click

      expect(app.home_page).to be_displayed
      expect(app.admin_users_show_page.full_name_field.text).to eq 'John Doe'
      expect(app.admin_users_show_page.field_by_label('Email').text).to eq 'Email: john_doe@example.com'
      expect(app.admin_users_show_page.field_by_label('First name').text).to eq 'First name: John'
      expect(app.admin_users_show_page.field_by_label('Last name').text).to eq 'Last name: Doe'
      expect(app.admin_users_show_page.field_by_label('Gender').text).to eq 'Gender: male'
      expect(app.admin_users_show_page.field_by_label('Age').text).to eq 'Age: 25'
    end

    scenario 'can select interests' do
      user = create(:user, :male, :older_than_30)
      create(:interest, name: 'Reading')
      create(:interest, name: 'Board Games')
      create(:interest, name: 'Running')

      app = App.new
      app.home_page.load
      app.login_page.login(user)

      app.home_page.edit_button.click
      expect(app.edit_profile_page).to be_displayed

      app.edit_profile_page.form.interests_field.select 'Reading'
      app.edit_profile_page.form.interests_field.select 'Board Games'
      app.edit_profile_page.form.confirm_button.click

      expect(app.home_page).to be_displayed
      expect(app.home_page.text).to include('Reading', 'Board Games')
      expect(app.home_page.text).to_not include 'Running'
    end
  end

  context 'Not signed in user' do
    scenario "Not signed in user can't edit his profile" do
      app = App.new
      app.home_page.load

      expect(app.login_page).to be_displayed
    end
  end
end
