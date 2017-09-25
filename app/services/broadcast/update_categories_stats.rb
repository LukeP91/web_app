class Broadcast::UpdateCategoriesStats < Pattern::ServicePattern
  def initialize(organization: organization)
    @organization = organization
  end

  private

  attr_reader :organization

  def call
    ActionCable.server.broadcast(
      'categories',
      users_by_category: UsersCountPerCategory.result_for(organization: organization)
    )
  end
end
