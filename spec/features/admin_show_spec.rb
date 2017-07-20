require "rails_helper"

describe "Admin show", type: :feature do
  before :each do
    @admin = create(:admin)
    @complete_user = create(:user_with_interests, :male, :older_than_30)
  end

  scenario "User with admin privileges can see other users profiles" do
    visit "/"
    within("#new_user") do
      fill_in 'Email', with: @admin.email
      fill_in 'Password', with: @admin.password
    end
    click_button 'Log in'
    click_link 'Admin Panel'
    expect(page).to have_css("h1", text: 'Users')
    page.find(:xpath, "//a[@href='/admin/users/#{@complete_user.id}']/../..").click_link('Show')
    expect(page).to have_css("h1", text: @complete_user.full_name)
    expect(page).to have_css("p", text: @complete_user.email)
    expect(page).to have_css("p", text: @complete_user.first_name)
    expect(page).to have_css("p", text: @complete_user.last_name)
    expect(page).to have_css("p", text: @complete_user.gender)
    expect(page).to have_css("p", text: @complete_user.age)
  end

  scenario "User without admin privileges can't see other users profiles" do
    visit "/"
    within("#new_user") do
      fill_in 'Email', with: @complete_user.email
      fill_in 'Password', with: @complete_user.password
    end
    click_button 'Log in'
    expect(page).to_not have_link 'Admin Panel'
    visit "/admin/users/#{@complete_user.id}"
    expect(current_path).to eq "/"
  end
end
