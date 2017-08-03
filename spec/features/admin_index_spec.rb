require "rails_helper"

describe "Admin listing", type: :feature do
  context 'user with admin privileges' do

    let(:organization) { create(:organization) }
    let(:admin) { create(:admin, organization: organization) }

    scenario "can access dashboard" do
      app = App.new
      app.home_page.load
      app.login_page.login(admin)
      expect(app.home_page).to be_displayed

      click_link 'Admin Panel'
      expect(app.admin_index_page).to be_displayed
    end

    scenario 'can see only users from his organization' do
      user = create(:user, organization: organization)
      user_in_other_org = create(:user)

      app = App.new
      app.home_page.load
      app.login_page.login(admin)
      expect(app.home_page).to be_displayed

      click_link 'Admin Panel'
      expect(app.admin_index_page).to be_displayed
      expect(app.admin_index_page.text).to include admin.full_name
      expect(app.admin_index_page.text).to include user.full_name
      expect(app.admin_index_page.text).to_not include user_in_other_org.full_name
    end
  end

  context 'user without admin privileges' do
    let(:user) { create(:user_with_interests, :male, :older_than_30) }

    scenario "can't access dashboard" do
      app = App.new
      app.home_page.load
      app.login_page.login(user)
      expect(app.home_page).to be_displayed

      expect(page).to_not have_link 'Admin Panel'
      app.admin_index_page.load
      expect(app.home_page).to be_displayed
    end
  end
end
