module Admin
  class IndexPage < SitePrism::Page
    section :menu, Sections::Menu, '.navbar'

    set_url '/admin/users'

    def show_button(id)
      find(:xpath, "//a[@href='/admin/users/#{id}']/span[text()='Show']/..")
    end

    def edit_button(id)
      find(:xpath, "//a[@href='/admin/users/#{id}/edit']")
    end

    def delete_button(id)
      find(:xpath, "//a[@href='/admin/users/#{id}' and @data-method='delete']")
    end
  end
end
