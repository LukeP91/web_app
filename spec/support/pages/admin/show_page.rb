class Admin::ShowPage < SitePrism::Page
  set_url "/admin/users/{id}"

  def show_button(id)
    find(:xpath, "//a[@href='/admin/users/#{id}']/span[text()='Show']/..")
  end

  def edit_button(id)
    find(:xpath, "//a[@href='/admin/users/edit/#{id}']")
  end
end
