class TweetsCountPerHashtag < Patterns::Calculation
  private

  def result
    tweets_count.sort do |current_hashtag, next_hashtag|
      comparison = next_hashtag[1] <=> current_hashtag[1]
      comparison.zero? ? current_hashtag[0] <=> next_hashtag[0] : comparison
    end
  end

  def organization
    options.fetch(:organization)
  end

  def tweets_count
    HashTag.in_organization(organization).inject([]) do |count, tag|
      count << [tag.name, tag.tweets.count]
    end
  end
end
