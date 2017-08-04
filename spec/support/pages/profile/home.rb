module Profile
  class Home < SitePrism::Page
    section :menu, Sections::Menu, '.navbar'
    set_url '/'

    element :edit_button, "#edit_button"

    def find_fullname(full_name)
      page.find(:xpath, "#full_name")
    end
  end
end
