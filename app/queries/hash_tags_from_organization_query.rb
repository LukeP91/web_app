class HashTagsFromOrganizationQuery < Patterns::Query
  queries HashTag

  private

  def query
    relation.joins(:tweets).where(tweets: { id: tweets_in_organization })
  end

  def organization
    options.fetch(:organization)
  end

  def tweets_in_organization
    Tweet.in_organization(organization).pluck(:id)
  end
end
