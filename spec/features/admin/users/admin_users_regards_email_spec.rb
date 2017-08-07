require 'rails_helper'

describe 'Admin send regards email', type: :feature do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  context 'User with admin priviliges' do

    let(:organization) { create(:organization) }
    let(:admin) { create(:admin, organization: organization) }

    scenario 'can send regards email to users from his organization' do
      user = create(:user, :male, :older_than_30, organization: organization)

      app = App.new
      app.home_page.load
      app.login_page.login(admin)
      expect(app.home_page).to be_displayed

      app.home_page.menu.admin_panel_link.click
      expect(app.admin_users_index_page).to be_displayed

      expect(LannisterMailer).to(receive(:regards_email).with(admin, user)).and_call_original
      app.admin_users_index_page.send_email_button(user.id).click
      mail = ActionMailer::Base.deliveries.last
      expect(mail).to deliver_to user.email
      expect(mail).to have_subject 'admin@example.com sends his regards'
    end

    scenario "can't send regards email to users outside his organization" do
      user = create(:user, :male, :older_than_30)

      app = App.new
      app.home_page.load
      app.login_page.login(admin)
      expect(app.home_page).to be_displayed

      app.home_page.menu.admin_panel_link.click
      expect(app.admin_users_index_page).to be_displayed
      expect(LannisterMailer).to_not(receive(:regards_email).with(admin, user))
      page.driver.submit :get, "/admin/users/#{user.id}/send_email", {}
      expect(app.admin_users_index_page).to be_displayed
    end
  end

  context 'User without admin privileges' do
    let(:user) { create(:user) }

    scenario "can't send regards email to other users" do
      app = App.new
      app.home_page.load
      app.login_page.login(user)
      expect(app.home_page).to be_displayed
      expect(LannisterMailer).to_not(receive(:regards_email).with(user, user))
      page.driver.submit :get, "/admin/users/#{user.id}/send_email", {}
      expect(app.home_page).to be_displayed
    end
  end
end
