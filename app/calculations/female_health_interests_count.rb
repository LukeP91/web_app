class FemaleHealthInterestsCount < Patterns::Calculation
  private

  AGE_RANGE = (20..30).freeze
  INTEREST_PREFIX = 'cosm'.freeze
  INTEREST_CATEGORY = 'health'.freeze

  def result
    interests.joins(:users_interests).where(users_interests: { user_id: users }).count
  end

  def organization
    options.fetch(:organization)
  end

  def users
    User.in_organization(organization).with_gender('female').with_age_between(AGE_RANGE)
  end

  def interests
    Interest.with_name_starting_with(INTEREST_PREFIX).with_category(INTEREST_CATEGORY)
  end
end
