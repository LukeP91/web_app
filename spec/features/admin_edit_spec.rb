require 'rails_helper'

describe 'Admin edit', type: :feature do
  context 'User with admin priviliges' do
    let(:organization) { create(:organization) }
    let(:admin) { create(:admin, organization: organization) }

    scenario 'can edit users from his organization' do
      create(:interest, name: 'test1')
      user = create(:user, :male, :older_than_30, organization: organization)
      modified_user = {
        email: 'changed_email@example.com',
        first_name: 'Modified',
        last_name: 'Modified',
        gender: 'female',
        age: 15
      }

      app = App.new
      app.home_page.load
      app.login_page.login(admin)
      expect(app.home_page).to be_displayed

      app.home_page.menu.admin_panel_link.click
      expect(app.admin_index_page).to be_displayed

      app.admin_index_page.edit_button(user.id).click
      app.admin_edit_page.email_field.set modified_user[:email]
      app.admin_edit_page.first_name_field.set modified_user[:first_name]
      app.admin_edit_page.last_name_field.set modified_user[:last_name]
      app.admin_edit_page.gender_field.select modified_user[:gender]
      app.admin_edit_page.age_field.select modified_user[:age]
      app.admin_edit_page.interests_field.select 'test1'
      app.admin_edit_page.update_user_button.click

      expect(app.admin_show_page).to be_displayed
      expect(app.admin_show_page.text).to include "#{modified_user[:first_name]} #{modified_user[:last_name]}"
      expect(app.admin_show_page.text).to include modified_user[:email]
      expect(app.admin_show_page.text).to include modified_user[:first_name]
      expect(app.admin_show_page.text).to include modified_user[:last_name]
      expect(app.admin_show_page.text).to include modified_user[:gender]
      expect(app.admin_show_page.text).to include modified_user[:age].to_s
      expect(app.admin_show_page.text).to include 'test1'
    end

    scenario "can't edit users from his organization" do
      user = create(:user, :male, :older_than_30)

      app = App.new
      app.home_page.load
      app.login_page.login(admin)
      expect(app.home_page).to be_displayed

      app.home_page.menu.admin_panel_link.click
      expect(app.admin_index_page).to be_displayed

      expect(page).to_not have_xpath "//a[@href='/admin/users/#{user.id}/edit']"
      app.admin_edit_page.load(id: user.id)
      expect(app.admin_index_page).to be_displayed
    end
  end

  context 'User without admin privileges' do
    let(:user) { create(:user) }

    scenario "can't edit other users" do
      app = App.new
      app.home_page.load
      app.login_page.login(user)
      expect(app.home_page).to be_displayed

      app.admin_edit_page.load(id: user.id)
      expect(app.home_page).to be_displayed
    end
  end
end
#   scenario "User with admin privileges can edit users" do
#     visit "/"
#     within("#new_user") do
#       fill_in 'Email', with: @admin.email
#       fill_in 'Password', with: @admin.password
#     end
#     click_button 'Log in'
#     click_link 'Admin Panel'ś
#     expect(page).to have_css("h1", text: 'Users')
#     find_link(href: "/admin/users/#{@complete_user.id}/edit").click
#     fill_in 'First name', with: "Modified"
#     click_button 'Update User'
#     expect(page).to have_css("p", text: "Modified")
#   end

#   scenario "User without admin privileges can't edit users" do
#     visit "/"
#     within("#new_user") do
#       fill_in 'Email', with: @complete_user.email
#       fill_in 'Password', with: @complete_user.password
#     end
#     click_button 'Log in'
#     expect(page).to_not have_link 'Admin Panel'
#     visit "/admin/users/#{@complete_user.id}/edit"
#     expect(page).to have_css("h1", text: @complete_user.full_name)
#   end
# end
