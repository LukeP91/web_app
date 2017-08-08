module Admin
  module Users
    class ShowPage < SitePrism::Page
      set_url '/admin/users/{id}'

      element :full_name_field, '.page-header h1'

      def field_by_label(label)
        find(:css, 'p', text: label)
      end
    end
  end
end
