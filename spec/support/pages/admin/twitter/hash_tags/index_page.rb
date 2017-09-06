module Admin
  module Twitter
    module HashTags
      class IndexPage < SitePrism::Page
        set_url '/admin/hash_tags'

        def show_button(id)
          find(:css, "#hash_tag_show_#{id}")
        end
      end
    end
  end
end
