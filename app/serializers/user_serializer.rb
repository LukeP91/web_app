class UserSerializer
  include Rails.application.routes.url_helpers

  def initialize(resource)
    @resource = resource
  end

  def serialize(root_key: true)
    if root_key
      JSON.generate(data: resource_data)
    else
      resource_data
    end
  end

  private

  def resource_data
    data = { id: @resource.id, type: 'users', attributes: attributes, links: links }
    data.merge(relationships_data)
  end

  def attributes
    {
      first_name: @resource.first_name,
      last_name: @resource.last_name,
      email: @resource.email,
      age: @resource.age,
      gender: @resource.gender
    }
  end

  def links
    {
      self: link_to_self
    }
  end

  def link_to_self
    api_user_url(id: @resource.id, host: Rails.application.secrets.app_host)
  end

  def relationships_data
    if @resource.interests.any?
      { relationships: UserInterestsSerializer.new(@resource).serialize }
    else
      {}
    end
  end
end
