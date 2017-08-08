require 'rails_helper'

describe 'Admin interests index' do
  context 'user with admin privileges' do
    before do
      @organization = create(:organization)
      @admin = create(:admin, organization: @organization)
    end

    scenario 'can access interests index with only interests from his organization' do
      interest_from_organization = create(:interest, organization: @organization)
      interest_outside_organization = create(:interest)

      app = App.new
      app.home_page.load
      app.login_page.login(@admin)
      expect(app.home_page).to be_displayed

      app.home_page.menu.admin_interests_link.click
      expect(app.admin_interests_index_page).to be_displayed
      expect(app.admin_interests_index_page.text).to include interest_from_organization.name
      expect(app.admin_interests_index_page.text).to_not include interest_outside_organization.name
    end
  end

  context 'user without admin privileges' do
    before do
      @user = create(:user_with_interests, :male, :older_than_30)
    end

    scenario "can't access interests index" do
      app = App.new
      app.home_page.load
      app.login_page.login(@user)
      expect(app.home_page).to be_displayed

      expect(app.home_page.menu).to have_no_admin_interests_link
      app.admin_interests_index_page.load
      expect(app.home_page).to be_displayed
    end
  end
end
