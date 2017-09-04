class TweetsCountPerHashtag < Patterns::Calculation
  private

  def result
    HashTag.in_organization(organization).inject({}) do |count, tag|
      count.merge(tag.name.downcase.to_sym => tag.tweets.count)
    end
  end

  def organization
    options.fetch(:organization)
  end
end
