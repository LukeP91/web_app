require 'rails_helper'

describe 'Admin categories index' do
  context 'user with admin privileges' do
    scenario 'can access categories index with only categories from his organization' do
      organization = create(:organization)
      admin = create(:admin, organization: organization)
      create(:category, name: 'health', organization: organization)
      create(:category, name: 'work')

      app = App.new
      app.home_page.load
      app.login_page.login(admin)
      expect(app.home_page).to be_displayed

      app.home_page.menu.admin_categories_link.click
      expect(app.admin_categories_index_page).to be_displayed
      expect(app.admin_categories_index_page.text).to include 'health'
      expect(app.admin_categories_index_page.text).to_not include 'work'
    end
  end
end
