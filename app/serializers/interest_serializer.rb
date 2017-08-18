class InterestSerializer
  def initialize(resource)
    @resource = resource
  end

  def serialize
    { type: 'interests', id: @resource.id, data: resource_data }
  end

  private

  def resource_data
    { name: @resource.name, category: @resource.category_name }
  end
end
