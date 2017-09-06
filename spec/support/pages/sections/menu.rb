module Sections
  class Menu < SitePrism::Section
    element :admin_panel, 'a.dropdown-toggle'
    element :admin_panel_link, '#admin_users_index_link'
    element :admin_categories_link, '#admin_categories_index_link'
    element :admin_interests_link, '#admin_interests_index_link'
    element :admin_sources_link, '#admin_sources_index_link'
    element :admin_statistics_link, '#admin_statistics_show_link'
    element :admin_hash_tags_link, '#admin_hash_tags_index_link'
  end
end
