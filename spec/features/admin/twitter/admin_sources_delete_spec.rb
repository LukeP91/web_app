require 'rails_helper'

describe 'Admin Twitter source delete' do
  context 'user with admin privileges' do
    scenario 'can delete source from his organization' do
      organization = create(:organization)
      admin = create(:admin, first_name: 'Luke', last_name: 'Admin', organization: organization)
      create(:source, name: '#ruby', organization: organization)
      rails = create(:source, name: '#rails', organization: organization)

      app = App.new
      app.home_page.load
      app.login_page.login(admin)
      expect(app.home_page).to be_displayed

      app.home_page.menu.admin_sources_link.click
      expect(app.admin_sources_index_page).to be_displayed
      app.admin_sources_index_page.delete_button(rails.id).click
      expect(app.admin_sources_index_page.text).to include '#ruby'
      expect(app.admin_sources_index_page.text).to_not include '#rails'
    end
  end
end
