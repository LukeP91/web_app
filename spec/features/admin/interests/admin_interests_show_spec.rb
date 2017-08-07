require 'rails_helper'

describe 'Admin interests show', type: :feature do
  context 'User with admin privileges' do
    before do
      @organization = create(:organization)
      @admin = create(:admin, organization: @organization)
    end

    scenario 'can access interests from his organization' do
      interest = create(:interest, organization: @organization)

      app = App.new
      app.home_page.load
      app.login_page.login(@admin)
      expect(app.home_page).to be_displayed

      app.home_page.menu.admin_interests_link.click
      expect(app.admin_interests_index_page).to be_displayed

      app.admin_interests_index_page.show_button(interest.id).click
      expect(app.admin_interest_show_page).to be_displayed
      expect(app.admin_interest_show_page.text).to include interest.name
      expect(app.admin_interest_show_page.text).to include interest.organization.name
      expect(app.admin_interest_show_page.text).to include interest.category.name
    end

    scenario "can't access interests outside his organization" do
      interest = create(:interest)

      app = App.new
      app.home_page.load
      app.login_page.login(@admin)
      expect(app.home_page).to be_displayed

      app.home_page.menu.admin_interests_link.click
      expect(app.admin_interests_index_page).to be_displayed

      expect(page).to_not have_css "#interest_show_#{interest.id}"
      app.admin_interest_show_page.load(id: interest.id)
      expect(app.admin_interests_index_page).to be_displayed
    end
  end

  context 'User without admin privileges' do
    before do
      @user = create(:user)
    end

    scenario "can't access interest show page" do
      interest = create(:interest)

      app = App.new
      app.home_page.load
      app.login_page.login(@user)
      expect(app.home_page).to be_displayed

      app.admin_interest_show_page.load(id: interest.id)
      expect(app.home_page).to be_displayed
    end
  end
end
