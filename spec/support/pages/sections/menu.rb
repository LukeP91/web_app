module Sections
  class Menu < SitePrism::Section
    element :admin_panel_link, "a[href='/admin/users']"
    element :admin_categories_link, "a[href='/admin/categories']"
    element :admin_interests_link, "a[href='/admin/interests']"
  end
end
