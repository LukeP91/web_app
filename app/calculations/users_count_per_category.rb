class UsersCountPerCategory < Patterns::Calculation
  private

  def result
    Category.where(organization: organization).map do |category|
      {
        category: category.name,
        count: category.users.count
      }
    end
  end

  def organization
    options.fetch(:organization)
  end
end
