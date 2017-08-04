module Sections
  class Menu < SitePrism::Section
    element :admin_categories_link, "a[href='/admin/categories']"
    element :admin_panel_link, "a[href='/admin/users']"
  end
end
