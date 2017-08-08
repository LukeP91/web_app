require 'rails_helper'

describe 'Admin categories index' do
  context 'user with admin privileges' do
    before do
      @organization = create(:organization)
      @admin = create(:admin, organization: @organization)
    end

    scenario 'can access categories index with only categories from his organization' do
      category_from_organization = create(:category, name: 'health', organization: @organization)
      category_outside_organization = create(:category, name: 'work')

      app = App.new
      app.home_page.load
      app.login_page.login(@admin)
      expect(app.home_page).to be_displayed

      app.home_page.menu.admin_categories_link.click
      expect(app.admin_categories_index_page).to be_displayed
      expect(app.admin_categories_index_page.text).to include category_from_organization.name
      expect(app.admin_categories_index_page.text).to_not include category_outside_organization.name
    end
  end

  context 'user without admin privileges' do
    before do
      @user = create(:user_with_interests, :male, :older_than_30)
    end

    scenario "can't access categories index" do
      app = App.new
      app.home_page.load
      app.login_page.login(@user)
      expect(app.home_page).to be_displayed

      expect(app.home_page.menu).to have_no_admin_categories_link
      app.admin_categories_index_page.load
      expect(app.home_page).to be_displayed
    end
  end
end
