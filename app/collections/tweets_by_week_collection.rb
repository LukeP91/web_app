class TweetsByWeekCollection < Patterns::Collection
  private

  def collection
    group_by_weeks
  end

  def group_by_weeks
    weeks.map do |week|
      tweets = subject.where(tweet_created_at: week)
      Tweets::Week.new(week, tweets)
    end
  end

  def weeks
    subject.order(:tweet_created_at).map do |tweet|
      tweet.tweet_created_at.beginning_of_week..tweet.tweet_created_at.end_of_week
    end.uniq
  end
end
