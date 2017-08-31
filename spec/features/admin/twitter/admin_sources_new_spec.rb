require 'rails_helper'

describe 'Admin Twitter source index' do
  context 'user with admin privileges' do
    scenario 'can see only sources from his organization' do
      organization = create(:organization)
      admin = create(:admin, first_name: 'Luke', last_name: 'Admin', organization: organization)

      app = App.new
      app.home_page.load
      app.login_page.login(admin)
      expect(app.home_page).to be_displayed

      app.home_page.menu.admin_sources_link.click
      expect(app.admin_sources_index_page).to be_displayed
      app.admin_sources_index_page.create_source_button.click
      app.admin_sources_new_page.name.set '#js'
      app.admin_sources_new_page.confirm_button.click
      expect(app.admin_sources_index_page.text).to include '#js'
    end
  end
end
