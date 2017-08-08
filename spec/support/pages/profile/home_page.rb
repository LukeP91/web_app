module Profile
  class HomePage < SitePrism::Page
    section :menu, Sections::Menu, '.navbar'
    set_url '/'

    element :edit_button, "#edit_button"

    # def find_fullname(full_name)
    #   page.find(:xpath, "#full_name")
    # end

    element :full_name_field, '.page-header h1'

    def field_by_label(label)
      find(:css, 'p', text: label)
    end
  end
end
