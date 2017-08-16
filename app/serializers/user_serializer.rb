class UserSerializer
  def initialize(resource)
    @resource = resource
  end

  def serialize
    JSON.generate(jsonapi_hash)
  end

  private

  def jsonapi_hash
    { data: resource_hash }
  end

  def resource_hash
    { id: @resource.id, type: 'users', attributes: attributes_hash }
  end

  def attributes_hash
    {
      first_name: @resource.first_name,
      last_name: @resource.last_name,
      email: @resource.email,
      age: @resource.age,
      gender: @resource.gender
    }
  end
end
