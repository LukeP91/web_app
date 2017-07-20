require "rails_helper"

describe "Show profile", type: :feature do
  let(:user) { create(:user) }
  let(:complete_user) { create(:user_with_interests, :male, :older_than_30) }

  scenario "Signed in user can see his profile" do
    visit "/"
    within("#new_user") do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
    end
    click_button 'Log in'
    expect(page).to have_css("h1", text: user.full_name)
  end

  scenario "User with complete data can see all his info on profile" do
    visit "/"
    within("#new_user") do
      fill_in 'Email', with: complete_user.email
      fill_in 'Password', with: complete_user.password
    end
    click_button 'Log in'
    expect(page).to have_css("h1", text: complete_user.full_name)
    expect(page).to have_css("p", text: complete_user.email)
    expect(page).to have_css("p", text: complete_user.first_name)
    expect(page).to have_css("p", text: complete_user.last_name)
    expect(page).to have_css("p", text: complete_user.gender)
    expect(page).to have_css("p", text: complete_user.age)
  end

  scenario "Not signed in user can't see his profile" do
    visit "/profile"
    expect(page).to have_content "Log in"
  end
end
