require 'rails_helper'

describe 'Admin Facebook posts index' do
  context 'user with admin privileges' do
    scenario 'can see unsend tweets from his organization' do
      organization = create(:organization)
      admin = create(:admin, first_name: 'Luke', last_name: 'Admin', organization: organization)
      ruby = create(:source, name: '#ruby', organization: organization)
      js = create(:source, name: '#js')

      create(
        :tweet,
        user_name: 'luke_pawlik',
        message: 'Send message from organization',
        tweet_id: '1',
        sources: [ruby],
        sent_to_fb: true
      )

      create(
        :tweet,
        user_name: 'luke_pawlik',
        message: 'Unsend message from organization',
        tweet_id: '2',
        sources: [ruby],
        sent_to_fb: false
      )

      create(
        :tweet,
        user_name: 'luke_pawlik',
        message: 'Send messege from other organization',
        tweet_id: '3',
        sources: [js],
        sent_to_fb: true
      )

      app = App.new
      app.home_page.load
      app.login_page.login(admin)
      expect(app.home_page).to be_displayed

      app.home_page.menu.admin_facebook_posts_link.click
      expect(app.admin_facebook_posts_index_page).to be_displayed
      expect(app.admin_facebook_posts_index_page.text).to include 'Unsend message from organization'
      expect(app.admin_facebook_posts_index_page.text).to_not include 'Send message from organization'
      expect(app.admin_facebook_posts_index_page.text).to_not include 'Send messege from other organization'
    end

    scenario 'can send any of tweets listed to Facebook', js: true do
      organization = create(:organization)
      admin = create(:admin, first_name: 'Luke', last_name: 'Admin', organization: organization)
      ruby = create(:source, name: '#ruby', organization: organization)
      facebook_wrapper = double('FacebookWrapper')
      allow(FacebookWrapper).to receive(:new).with(organization).and_return(facebook_wrapper)
      allow(facebook_wrapper).to receive(:post_on_wall)

      tweet = create(
        :tweet,
        user_name: 'luke_pawlik',
        message: 'New blog post is up #rails #ruby',
        tweet_id: '1',
        sources: [ruby],
        organization: organization,
        sent_to_fb: false
      )

      app = App.new
      app.home_page.load
      app.login_page.login(admin)
      expect(app.home_page).to be_displayed
      app.home_page.menu.admin_panel.click
      app.home_page.menu.admin_facebook_posts_link.click
      expect(app.admin_facebook_posts_index_page).to be_displayed

      app.admin_facebook_posts_index_page.send_button(tweet.id).click
      expect(facebook_wrapper).to have_received(:post_on_wall).with('New blog post is up #rails #ruby')
    end
  end
end
