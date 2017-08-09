module Sections
  class Menu < SitePrism::Section
    element :admin_panel, 'a.dropdown-toggle'
    element :admin_panel_link, '#admin_users_index_link'
    element :admin_categories_link, '#admin_categories_index_link'
    element :admin_interests_link, '#admin_interests_index_link'
  end
end
