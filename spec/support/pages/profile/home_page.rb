module Profile
  class HomePage < SitePrism::Page
    section :menu, Sections::Menu, '.navbar'
    set_url '/'

    element :edit_button, '#edit_button'
    element :full_name_field, '.page-header h1'

    def field_by_label(label)
      find(:css, 'p', text: label)
    end
  end
end
