module Profile
  class EditPage < SitePrism::Page
    section :form, Sections::UserForm, '#form'

    set_url '/profile/edit'
  end
end
