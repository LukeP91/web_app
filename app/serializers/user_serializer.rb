class UserSerializer

  def initialize(resource, root_url)
    @resource = resource
    @root_url = root_url
  end

  def serialize
    JSON.generate(jsonapi)
  end

  private

  def jsonapi
    { data: resource }
  end

  def resource
    { id: @resource.id, type: 'users', attributes: attributes, links: links }
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
    { 'self' => "#{@root_url}admin/users/#{@resource.id}" }
  end

  def link_to_self
    binding.pry
  end
end
