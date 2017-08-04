module Admin
  module Users
    class NewPage < SitePrism::Page
      section :form, Sections::UserForm, '#form'
      set_url 'admin/users/new'
    end
  end
end
