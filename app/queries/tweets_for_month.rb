class TweetsForMonth < Patterns::Query
  queries Tweet

  private

  def query
    relation.where(tweet_created_at: date_range, organization: organization)
  end

  def organization
    options.fetch(:organization)
  end

  def date
    options.fetch(:date, Date.today).to_datetime
  end

  def date_range
    date.beginning_of_month..date.end_of_month
  end
end
