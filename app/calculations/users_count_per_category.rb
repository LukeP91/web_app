class UsersCountPerCategory < Patterns::Calculation
  private

  def result
    Category.where(organization: organization).map do |category|
      {
        category: category.name,
        count: users_count(category)
      }
    end
  end

  def organization
    options.fetch(:organization)
  end

  def users_count(category)
    category.users.count
  end
end
