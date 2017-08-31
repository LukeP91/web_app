module Admin
  module Twitter
    module Sources
      class IndexPage < SitePrism::Page
        set_url '/admin/sources'

        element :create_source_button, '#new_source'

        def delete_button(id)
          find(:css, "#source_delete_#{id}")
        end
      end
    end
  end
end
