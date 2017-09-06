require 'rails_helper'

describe 'Admin hash tags show' do
  context 'User with admin privileges' do
    scenario 'can access tweet list for given hashtag within his organization' do
      organization = create(:organization)
      admin = create(:admin, first_name: 'Luke', last_name: 'Admin', organization: organization)
      source = create(:source, name: '#ruby')
      hashtag = create(:hash_tag, name: '#ruby', organization: organization)
      create(
        :tweet,
        user_name: "luke_pawlik",
        message: 'test message #ruby',
        tweet_id: '1232132',
        sources: [source],
        hash_tags: [hashtag]
      )

      app = App.new
      app.home_page.load
      app.login_page.login(admin)
      expect(app.home_page).to be_displayed

      app.home_page.menu.admin_hash_tags_link.click
      expect(app.admin_hash_tags_index_page).to be_displayed
      expect(app.admin_hash_tags_index_page.text).to include '#ruby'

      app.admin_hash_tags_index_page.show_button(hashtag.id).click
      expect(app.admin_hash_tag_show_page).to be_displayed
      expect(app.admin_hash_tag_show_page.text).to include '1'
      expect(app.admin_hash_tag_show_page.text).to include 'luke_pawlik'
      expect(app.admin_hash_tag_show_page.text).to include '1232132'
      expect(app.admin_hash_tag_show_page.text).to include 'test message #ruby'
    end
  end
end
