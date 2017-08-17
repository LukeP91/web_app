class UsersSerializer
  def initialize(resources)
    @resources  = resources
  end

  def serialize
    JSON.generate(data: resources_data)
  end

  private

  def resources_data
    @resources.map{ |resource| UserSerializer.new(resource).serialize(root_key: false) }
  end
end
