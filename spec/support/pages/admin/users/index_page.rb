module Admin
  module Users
    class IndexPage < SitePrism::Page
      section :menu, Sections::Menu, '.navbar'

      set_url '/admin/users{?query*}'

      element :search_field, '#user_search > input[type="search"]:nth-child(2)'
      element :search_button, '#user_search > input.btn.btn-default'
      element :create_user_button, '#new_user'

      def show_button(id)
        find(:css, "#user_show_#{id}")
      end

      def edit_button(id)
        find(:css, "#user_edit_#{id}")
      end

      def delete_button(id)
        find(:css, "#user_delete_#{id}")
      end
    end
  end
end
