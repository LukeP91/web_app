require "rails_helper"

describe "Admin delete", type: :feature do
  before :each do
    @admin = create(:admin)
    @complete_user = create(:user_with_interests, :male, :older_than_30)
  end

  scenario "User with admin privileges can delete users" do
    visit "/"
    within("#new_user") do
      fill_in 'Email', with: @admin.email
      fill_in 'Password', with: @admin.password
    end
    click_button 'Log in'
    click_link 'Admin Panel'
    expect(page).to have_css("h1", text: 'Users')
    page.find(:xpath, "//a[@href='/admin/users/#{@complete_user.id}']/../../td[7]/a[3]").click
    expect(page.all('table tr').count).to eq 2
  end

  scenario "Admin should not be able to delete himself" do
    visit "/"
    within("#new_user") do
      fill_in 'Email', with: @admin.email
      fill_in 'Password', with: @admin.password
    end
    click_button 'Log in'
    click_link 'Admin Panel'
    admin_row = page.find(:xpath, "//a[@href='/admin/users/#{@admin.id}']/../../td[7]")
    expect(admin_row.all('a').count).to eq 3
  end
end
