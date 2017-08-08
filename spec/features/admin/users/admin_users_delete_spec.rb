require 'rails_helper'

describe 'Admin::Users#delete' do
  context 'User with admin privileges' do
    scenario 'can delete other users from his organization' do
      organization = create(:organization)
      admin = create(:admin, organization: organization)
      user = create(:user, organization: organization)

      app = App.new
      app.home_page.load
      app.login_page.login(admin)
      expect(app.home_page).to be_displayed

      app.home_page.menu.admin_panel_link.click
      expect(app.admin_users_index_page).to be_displayed
      app.admin_users_index_page.delete_button(user.id).click
      expect(app.admin_users_index_page).to be_displayed
      expect(User.count).to eq 1
    end

    scenario "can't delete users outside his organization" do
      admin = create(:admin)
      user = create(:user)

      app = App.new
      app.home_page.load
      app.login_page.login(admin)
      expect(app.home_page).to be_displayed

      app.home_page.menu.admin_panel_link.click
      expect(app.admin_users_index_page).to be_displayed

      expect(page).to_not have_css "#user_delete_#{user.id}"
      page.driver.submit :delete, "/admin/users/#{user.id}", {}
      expect(app.admin_users_index_page).to be_displayed
      expect(User.count).to eq 2
    end

    scenario "can't delete himself" do
      admin = create(:admin)

      app = App.new
      app.home_page.load
      app.login_page.login(admin)
      expect(app.home_page).to be_displayed

      app.home_page.menu.admin_panel_link.click
      expect(app.admin_users_index_page).to be_displayed
      expect(page).to_not have_css "#user_delete_#{admin.id}"
      page.driver.submit :delete, "/admin/users/#{admin.id}", {}
      expect(app.admin_users_index_page).to be_displayed
      expect(User.count).to eq 1
    end
  end

  context 'User without admin privileges' do
    scenario "can't delete other users" do
      user = create(:user)

      app = App.new
      app.home_page.load
      app.login_page.login(user)
      expect(app.home_page).to be_displayed

      page.driver.submit :delete, "/admin/users/#{user.id}", {}
      expect(app.home_page).to be_displayed
      expect(User.count).to eq 1
    end
  end
end
