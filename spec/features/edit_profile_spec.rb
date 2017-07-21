require "rails_helper"

describe "Edit profile", type: :feature do
  before :each do
    @user = create(:user, :male, :older_than_30)
  end

  let(:modified_user) { { email: "changed_email@example.com",
                          first_name: "Modified",
                          last_name: "Modified",
                          gender: "female",
                          age: 15 } }

  scenario "Signed in user can edit his profile" do
    visit "/"
    within("#new_user") do
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
    end
    click_button 'Log in'
    click_link 'Edit'
    expect(page).to have_css("h1", text: "Edit User")

    fill_in 'Email', with: modified_user[:email]
    fill_in 'First name', with: modified_user[:first_name]
    fill_in 'Last name', with: modified_user[:last_name]
    select modified_user[:gender], from: 'Gender'
    select modified_user[:age], from: 'Age'
    click_button 'Update User'

    expect(page).to have_css("h1", text: "#{modified_user[:first_name]} #{modified_user[:last_name] }")
    expect(page).to have_css("p", text: modified_user[:email])
    expect(page).to have_css("p", text: modified_user[:first_name])
    expect(page).to have_css("p", text: modified_user[:last_name])
    expect(page).to have_css("p", text: modified_user[:gender])
    expect(page).to have_css("p", text: modified_user[:age])
  end

  scenario "Signed in user can add interest to his profile" do
    visit "/"
    within("#new_user") do
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
    end
    click_button 'Log in'
    click_link 'Edit'
    expect(page).to have_css("h1", text: "Edit User")
    click_link 'add interest'
    # add sleep to wait for name element
    within('#interests') do
      fill_in 'Name', with: "Interest"
      select 'health', from: 'Category'
    end
    click_button 'Update User'
  end

  scenario "Not signed in user can't edit his profile" do
    visit "/profile/edit"
    expect(page).to have_content "Log in"
  end
end
