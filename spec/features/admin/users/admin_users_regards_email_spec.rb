require 'rails_helper'

describe 'Admin send regards email' do
  include EmailSpec::Helpers
  include EmailSpec::Matchers
  include ActiveJob::TestHelper

  context 'User with admin priviliges' do
    scenario 'can send regards email to users from his organization', js: true do
      organization = create(:organization)
      admin = create(:admin, email: 'admin@example.com', organization: organization)
      user = create(:user, email: 'user_email@example.com', organization: organization)
      app = App.new
      app.home_page.load
      app.login_page.login(admin)
      expect(app.home_page).to be_displayed
      app.home_page.menu.admin_panel.click
      app.home_page.menu.admin_panel_link.click
      expect(app.admin_users_index_page).to be_displayed

      perform_enqueued_jobs do
        expect(LannisterMailer).to(receive(:regards_email).with(admin, user)).and_call_original
        app.admin_users_index_page.send_email_button(user.id).click
        sleep(1)
        mail = ActionMailer::Base.deliveries.last
        expect(mail).to deliver_to 'user_email@example.com'
        expect(mail).to have_subject 'admin@example.com sends his regards'
      end
    end
  end
end
