require 'rails_helper'
require 'support/pages/app'

describe 'Show profile' do
  context 'signed in user' do
    scenario 'with complete data can see all his info on profile' do
      user = create(:user_with_interests, :male, email: 'joe.doe@example.com', first_name: 'Joe', last_name: 'Doe', age: 25)
      app = App.new
      app.home_page.load
      app.login_page.login(user)
      expect(app.home_page).to be_displayed

      expect(app.home_page.full_name_field.text).to eq 'Joe Doe'
      expect(app.home_page.field_by_label('Email').text).to eq 'Email: joe.doe@example.com'
      expect(app.home_page.field_by_label('First name').text).to eq 'First name: Joe'
      expect(app.home_page.field_by_label('Last name').text).to eq 'Last name: Doe'
      expect(app.home_page.field_by_label('Gender').text).to eq 'Gender: male'
      expect(app.home_page.field_by_label('Age').text).to eq 'Age: 25'
    end
  end

  context 'not signed in user' do
    scenario "can't see his profile" do
      app = App.new
      app.home_page.load

      expect(app.login_page).to be_displayed
    end
  end
end
