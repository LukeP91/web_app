class UsersSerializer
  include Rails.application.routes.url_helpers

  def initialize(resources, page = 1, per_page = User.per_page)
    @resources = resources
    @page = page.to_i
    @per_page = per_page.to_i
  end

  def serialize
    JSON.generate(links: links, data: resources_data)
  end

  private

  def resources_data
    @resources.map { |resource| UserSerializer.new(resource).serialize(root_key: false) }
  end

  def links
    links_members = {}
    links_members[:self] = link_to_self.to_s
    if total_pages > 1
      unless first_page?
        links_members[:first] = "#{link_to_self}?page=1&per_page=#{@per_page}"
        links_members[:prev] = "#{link_to_self}?page=#{prev_page}&per_page=#{@per_page}"
      end
      unless last_page?
        links_members[:next] = "#{link_to_self}?page=#{next_page}&per_page=#{@per_page}"
        links_members[:last] = "#{link_to_self}?page=#{total_pages}&per_page=#{@per_page}"
      end
    end
    links_members
  end

  def link_to_self
    api_users_url(host: Rails.application.secrets.app_host)
  end

  def total_pages
    User.pages(@per_page)
  end

  def prev_page
    @page - 1
  end

  def next_page
    @page + 1
  end

  def first_page?
    @page == 1
  end

  def last_page?
    @page == total_pages
  end
end
