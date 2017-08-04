require 'rails_helper'

describe 'Edit profile', type: :feature do
  context 'signed in user' do
    before do
      @user = create(:user, :male, :older_than_30)
    end

    let(:modified_user) do
      {
        email: 'changed_email@example.com',
        first_name: 'Modified',
        last_name: 'Modified',
        gender: 'female',
        age: 15
      }
    end

    scenario 'can edit his profile' do
      app = App.new
      app.home_page.load
      app.login_page.login(@user)

      app.home_page.edit_button.click
      expect(app.edit_profile_page).to be_displayed

      app.edit_profile_page.form.email_field.set modified_user[:email]
      app.edit_profile_page.form.first_name_field.set modified_user[:first_name]
      app.edit_profile_page.form.last_name_field.set modified_user[:last_name]
      app.edit_profile_page.form.gender_field.select modified_user[:gender]
      app.edit_profile_page.form.age_field.select modified_user[:age]
      app.edit_profile_page.form.confirm_button.click

      expect(app.home_page).to be_displayed
      expect(app.home_page.text).to include "#{modified_user[:first_name]} #{modified_user[:last_name]}"
      expect(app.home_page.text).to include modified_user[:email]
      expect(app.home_page.text).to include modified_user[:first_name]
      expect(app.home_page.text).to include modified_user[:last_name]
      expect(app.home_page.text).to include modified_user[:gender]
      expect(app.home_page.text).to include modified_user[:age].to_s
    end

    scenario 'can select interests' do
      create(:interest, name: 'test1')
      create(:interest, name: 'test2')
      create(:interest, name: 'test3')

      app = App.new
      app.home_page.load
      app.login_page.login(@user)

      app.home_page.edit_button.click
      expect(app.edit_profile_page).to be_displayed

      app.edit_profile_page.form.interests_field.select 'test1'
      app.edit_profile_page.form.interests_field.select 'test2'
      app.edit_profile_page.form.confirm_button.click

      expect(app.home_page).to be_displayed
      expect(app.home_page.text).to include('test1', 'test2')
      expect(app.home_page.text).to_not include 'test3'
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
