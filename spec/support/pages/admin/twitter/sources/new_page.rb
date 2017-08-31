module Admin
  module Twitter
    module Sources
      class CreatePage < SitePrism::Page
        set_url '/admin/sources/new'

        element :name, '#source_name'
        element :confirm_button, "input[name='commit']"
      end
    end
  end
end
