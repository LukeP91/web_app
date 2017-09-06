module Admin
  module Twitter
    module HashTags
      class ShowPage < SitePrism::Page
        set_url '/admin/hash_tags/{id}'
      end
    end
  end
end
