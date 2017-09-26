class UsersByAge < Patterns::Calculation
  private

  AGE_RANGES = {
    'Child: <0-10)' => 0..9,
    'Teen: <10-18)' => 10..17,
    'Adult: <18-65)' => 18..64,
    'Elderly: <65-100)' => 65..99
  }.freeze

  def result
    age_ranges_stats.map{ |age_range, users_count| { range: age_range, count: users_count } }
  end

  def organization
    options.fetch(:organization)
  end

  def users_age
    User.where(organization: organization).order(:age).pluck(:age)
  end

  def age_ranges_stats
    users_age.group_by do |age|
      AGE_RANGES.find { |_, age_range| age_range === age }.first
    end.transform_values(&:count)
  end
end
