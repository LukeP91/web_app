module Profile
  class Home < SitePrism::Page
    section :menu, Sections::Menu, '.navbar'
    set_url '/'

    element :edit_button, "a[href='/profile/edit']"

    def find_fullname(full_name)
      page.find(:xpath, "(//h1[contains(text(), '#{full_name}')])")
    end
  end
end
