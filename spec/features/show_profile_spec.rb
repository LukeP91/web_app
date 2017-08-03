require 'rails_helper'
require 'support/pages/home'
require 'support/pages/login_page'

describe 'Show profile', type: :feature do
  let(:user) { create(:user) }
  let(:complete_user) { create(:user_with_interests, :male, :older_than_30) }

  scenario 'Signed in user can see his profile' do
    @home_page = Home.new
    @home_page.load

    @login_page = LoginPage.new
    @login_page.email_field.set user.email
    @login_page.password_field.set user.password
    @login_page.login_button.click

    expect(page).to have_css('h1', text: user.full_name)
  end

  scenario 'User with complete data can see all his info on profile' do
    @home_page = Home.new
    @home_page.load

    @login_page = LoginPage.new
    @login_page.email_field.set complete_user.email
    @login_page.password_field.set complete_user.password
    @login_page.login_button.click

    expect(page).to have_css('h1', text: complete_user.full_name)
    expect(page).to have_css('p', text: complete_user.email)
    expect(page).to have_css('p', text: complete_user.first_name)
    expect(page).to have_css('p', text: complete_user.last_name)
    expect(page).to have_css('p', text: complete_user.gender)
    expect(page).to have_css('p', text: complete_user.age)
  end

  scenario "Not signed in user can't see his profile" do
    @home_page = Home.new
    @home_page.load

    expect(page).to have_content 'Log in'
  end
end
