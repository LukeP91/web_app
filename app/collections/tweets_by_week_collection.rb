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
    options.fetch(:weeks)
  end
end
