require "rails_helper"

describe "Admin listing", type: :feature do
  let(:admin) { create(:admin) }
  let(:complete_user) { create(:user_with_interests, :male, :older_than_30) }

  scenario "User with admin privileges can access dashboard" do
    visit "/"
    within("#new_user") do
      fill_in 'Email', with: admin.email
      fill_in 'Password', with: admin.password
    end
    click_button 'Log in'
    click_link 'Admin Panel'
    expect(page).to have_css("h1", text: 'Users')
  end

  scenario "User without admin privileges can't access dashboard" do
    visit "/"
    within("#new_user") do
      fill_in 'Email', with: complete_user.email
      fill_in 'Password', with: complete_user.password
    end
    click_button 'Log in'
    expect(page).to_not have_link 'Admin Panel'
    visit "/admin/users"
    expect(page).to have_css("h1", text: complete_user.full_name)
  end
end
