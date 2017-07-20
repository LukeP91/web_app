require "rails_helper"

describe "Admin edit", type: :feature do
  before :each do
    @admin = create(:admin)
    @complete_user = create(:user_with_interests, :male, :older_than_30)
  end

  scenario "User with admin privileges can edit users" do
    visit "/"
    within("#new_user") do
      fill_in 'Email', with: @admin.email
      fill_in 'Password', with: @admin.password
    end
    click_button 'Log in'
    click_link 'Admin Panel'
    expect(page).to have_css("h1", text: 'Users')
    find_link(href: "/admin/users/#{@complete_user.id}/edit").click
    fill_in 'First name', with: "Modified"
    click_button 'Update User'
    expect(page).to have_css("p", text: "Modified")
  end

  scenario "User without admin privileges can't edit users" do
    visit "/"
    within("#new_user") do
      fill_in 'Email', with: @complete_user.email
      fill_in 'Password', with: @complete_user.password
    end
    click_button 'Log in'
    expect(page).to_not have_link 'Admin Panel'
    visit "/admin/users/#{@complete_user.id}/edit"
    expect(page).to have_css("h1", text: @complete_user.full_name)
  end
end
