require 'rails_helper'

describe 'Admin::Users#delete', type: :feature do
  context 'User with admin privileges' do
    let(:organization) { create(:organization) }
    let(:admin) { create(:admin, organization: organization) }

    scenario 'can delete other users from his organization' do
      user = create(:user_with_interests, :male, :older_than_30, organization: organization)
      app = App.new
      app.home_page.load
      app.login_page.login(admin)
      expect(app.home_page).to be_displayed

      app.home_page.menu.admin_panel_link.click
      expect(app.admin_index_page).to be_displayed
      app.admin_index_page.delete_button(user.id).click
      expect(app.admin_index_page).to be_displayed
      expect(User.count).to eq 1
    end

    scenario "can't delete users outside his organization" do
      user = create(:user_with_interests, :male, :older_than_30)

      app = App.new
      app.home_page.load
      app.login_page.login(admin)
      expect(app.home_page).to be_displayed

      app.home_page.menu.admin_panel_link.click
      expect(app.admin_index_page).to be_displayed

      expect(page).to_not have_css "#user_delete_#{user.id}"
      page.driver.submit :delete, "/admin/users/#{user.id}", {}
      expect(app.admin_index_page).to be_displayed
      expect(User.count).to eq 2
    end

    scenario "can't delete himself" do
      app = App.new
      app.home_page.load
      app.login_page.login(admin)
      expect(app.home_page).to be_displayed

      app.home_page.menu.admin_panel_link.click
      expect(app.admin_index_page).to be_displayed
      expect(page).to_not have_css "#user_delete_#{admin.id}"
      page.driver.submit :delete, "/admin/users/#{admin.id}", {}
      expect(app.admin_index_page).to be_displayed
      expect(User.count).to eq 1
    end
  end

  context 'User without admin privileges' do
    let(:user) { create(:user) }

    scenario "can't see other users profiles" do
      app = App.new
      app.home_page.load
      app.login_page.login(user)
      expect(app.home_page).to be_displayed

      app.admin_show_page.load(id: user.id)
      page.driver.submit :delete, "/admin/users/#{user.id}", {}
      expect(app.home_page).to be_displayed
      expect(User.count).to eq 1
    end
  end
end
