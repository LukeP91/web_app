class TweetsCountPerHashtag < Patterns::Calculation
  private

  def result
    sorted_hashtag_stats.take(limit)
  end

  def organization
    options.fetch(:organization)
  end

  def limit
    options.fetch(:limit)
  end

  def tweets_count
    HashTag.in_organization(organization).inject([]) do |hashtags_stats, tag|
      hashtags_stats << { name: tag.name, count: tag.tweets_count }
    end
  end

  def sorted_hashtag_stats
    tweets_count.sort do |current_hashtag, next_hashtag|
      comparison = next_hashtag[:count] <=> current_hashtag[:count]
      comparison.zero? ? current_hashtag[:name] <=> next_hashtag[:name] : comparison
    end
  end
end
