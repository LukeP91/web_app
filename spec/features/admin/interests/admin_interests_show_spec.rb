require 'rails_helper'

describe 'Admin interests show' do
  context 'User with admin privileges' do
    scenario 'can access interests from his organization' do
      organization = create(:organization, name: 'Google')
      admin = create(:admin, organization: organization)
      category = create(:category, name: 'work', organization: organization)
      interest = create(:interest, name: 'Reading', category: category, organization: organization)

      app = App.new
      app.home_page.load
      app.login_page.login(admin)
      expect(app.home_page).to be_displayed

      app.home_page.menu.admin_interests_link.click
      expect(app.admin_interests_index_page).to be_displayed

      app.admin_interests_index_page.show_button(interest.id).click
      expect(app.admin_interest_show_page).to be_displayed
      expect(app.admin_interest_show_page.text).to include 'Reading'
      expect(app.admin_interest_show_page.text).to include 'Google'
      expect(app.admin_interest_show_page.text).to include 'work'
    end
  end
end
