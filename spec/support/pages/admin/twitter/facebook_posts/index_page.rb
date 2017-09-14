module Admin
  module Twitter
    module FacebookPosts
      class IndexPage < SitePrism::Page
        set_url '/admin/facebook_posts'

        def send_button(id)
          find(:css, "#send-to-fb-#{id}")
        end
      end
    end
  end
end
