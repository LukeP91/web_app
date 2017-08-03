class Admin::ShowPage < SitePrism::Page
  set_url "/admin/users{/user_id}"

  element :show_button, "//a[@href='/admin/users{/user_id}']/../..//a[text()='Show']"
end
