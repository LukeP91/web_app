class Tweets::Report
  MONTH_FORMAT = '%m.%Y'.freeze
  WEEK_FORMAT = '%W'.freeze

  def initialize(organization, month)
    @organization = organization
    @month = month
  end

  def generate_report
    tweets_by_week.map(&:formatted).join
  end

  private

  def tweets_by_week
    tweets = Tweet.where(tweet_created_at: date_range)
    TweetsByWeekCollection.new(tweets, weeks: days_by_weeks)
  end

  def date_range
    first_day = month.beginning_of_month.beginning_of_week
    last_day = month.end_of_month.end_of_week.end_of_day
    first_day..last_day
  end

  def month
    DateTime.strptime(@month, MONTH_FORMAT)
  end

  def days_by_weeks
    date_range.group_by { |day| day.strftime(WEEK_FORMAT) }.keys.map do |week|
      week_first_day = DateTime.strptime(week, WEEK_FORMAT)
      week_first_day..week_first_day.end_of_week.end_of_day
    end
  end
end
