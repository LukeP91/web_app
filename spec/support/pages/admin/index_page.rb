module Admin
  class IndexPage < SitePrism::Page
    section :menu, Sections::Menu, '.navbar'

    set_url '/admin/users'
  end
end
