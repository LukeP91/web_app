require 'rails_helper'

describe 'Admin send regards email', type: :feature do
  include ActiveJob::TestHelper

  context 'User with admin priviliges' do
    before { clear_enqueued_jobs }

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

      app.admin_users_index_page.send_email_button(user.id).click
      mail = ActionMailer::Base.deliveries.last
      expect(ActionMailer::Base.deliveries.count).to eq 1
      expect(mail.to).to eq [user.email]
      expect(mail.subject).to have_content 'admin@example.com sends his regards'
    end

    scenario "can't send regards email to users outside his organization" do
      user = create(:user, :male, :older_than_30)

      app = App.new
      app.home_page.load
      app.login_page.login(admin)
      expect(app.home_page).to be_displayed

      app.home_page.menu.admin_panel_link.click
      expect(app.admin_users_index_page).to be_displayed

      expect(page).to_not have_css "user_send_email_#{user.id}"
      page.driver.submit :get, "/admin/users/#{user.id}/send_email", {}
      expect(ActionMailer::Base.deliveries.count).to eq 0
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

      page.driver.submit :get, "/admin/users/#{user.id}/send_email", {}
      expect(ActionMailer::Base.deliveries.count).to eq 0
      expect(app.home_page).to be_displayed
    end
  end
end
