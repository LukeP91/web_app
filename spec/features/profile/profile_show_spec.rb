require 'rails_helper'
require 'support/pages/app'

describe 'Show profile' do
  context 'signed in user' do
    before do
      @user = create(:user)
      @complete_user = create(:user_with_interests, :male, :older_than_30)
    end

    scenario 'with mandatory data can see basic info on profile' do
      app = App.new
      app.home_page.load
      app.login_page.login(@user)
      expect(app.home_page).to be_displayed

      expect(app.home_page.text).to include @user.full_name
      expect(app.home_page.text).to include @user.email
      expect(app.home_page.text).to include @user.first_name
      expect(app.home_page.text).to include @user.last_name
      expect(app.home_page.text).to_not include 'Gender'
      expect(app.home_page.text).to_not include 'Age'
    end

    scenario 'with complete data can see all his info on profile' do
      app = App.new
      app.home_page.load
      app.login_page.login(@complete_user)
      expect(app.home_page).to be_displayed

      expect(app.home_page.text).to include @complete_user.full_name
      expect(app.home_page.text).to include @complete_user.email
      expect(app.home_page.text).to include @complete_user.first_name
      expect(app.home_page.text).to include @complete_user.last_name
      expect(app.home_page.text).to include @complete_user.gender
      expect(app.home_page.text).to include @complete_user.age.to_s
    end
  end

  context 'not signed in user' do
    scenario "can't see his profile" do
      app = App.new
      app.home_page.load

      expect(app.login_page).to be_displayed
    end
  end
end
