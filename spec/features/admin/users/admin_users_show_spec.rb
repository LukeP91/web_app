require 'rails_helper'

describe 'Admin show' do
  context 'User with admin privileges' do
    scenario 'can see users profiles from his organization' do
      organization = create(:organization)
      admin = create(:admin, organization: organization)
      user = create(:user_with_interests, email: 'john.doe@example.com', first_name: 'John', last_name: 'Doe', age: 25, gender: 'male', organization: organization)

      app = App.new
      app.home_page.load
      app.login_page.login(admin)
      expect(app.home_page).to be_displayed

      app.home_page.menu.admin_panel_link.click
      expect(app.admin_users_index_page).to be_displayed

      app.admin_users_index_page.show_button(user.id).click
      expect(app.admin_users_show_page).to be_displayed
      expect(app.admin_users_show_page.full_name_field.text).to eq 'John Doe'
      expect(app.admin_users_show_page.field_by_label('Email').text).to eq 'Email: john.doe@example.com'
      expect(app.admin_users_show_page.field_by_label('First name').text).to eq 'First name: John'
      expect(app.admin_users_show_page.field_by_label('Last name').text).to eq 'Last name: Doe'
      expect(app.admin_users_show_page.field_by_label('Gender').text).to eq 'Gender: male'
      expect(app.admin_users_show_page.field_by_label('Age').text).to eq 'Age: 25'
    end
  end
end
