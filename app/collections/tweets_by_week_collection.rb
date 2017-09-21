class TweetsByWeekCollection < Patterns::Collection
  private

  def collection
    group_by_weeks
  end

  def group_by_weeks
    weeks.map do |week|
      tweets = subject.where(tweet_created_at: week)
      unless tweets.empty?
        week = Tweets::Week.new(week, tweets)
        [week.title, week]
      end
    end.compact
  end

  def weeks
    day_within_month = subject.first.tweet_created_at.to_datetime
    (day_within_month.beginning_of_month..day_within_month.end_of_month).map do |day|
      day.beginning_of_week..day.end_of_week
    end.uniq
  end
end
