module Admin
  module Interests
    class IndexPage < SitePrism::Page
      set_url '/admin/interests'

      def show_button(id)
        find(:css, "#interest_show_#{id}")
      end
    end
  end
end
