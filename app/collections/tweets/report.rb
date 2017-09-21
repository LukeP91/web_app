class Tweets::Report
  MONTH_FORMAT = '%m.%Y'.freeze

  def initialize(organization, month)
    @organization = organization
    @month = month
  end

  def generate_report
    report = ''
    tweets_by_week.each do |week_title, days|
      report << "Week: #{week_title}\n"
      days.each do |day_title, tweets|
        report << " Day: #{day_title}\n"
        if !tweets.empty?
          tweets.each do |tweet|
            report << "   #{tweet.id} - sent to facebook? #{tweet.status} for #{tweet.date}\n"
          end
        else
          report << "   No tweets found for that day\n"
        end
      end
    end
    report
  end

  private

  def tweets_by_week
    tweets = Tweet.where(tweet_created_at: date_range)
    TweetsByWeekCollection.new(tweets, weeks: weeks)
  end

  def date_range
    month.beginning_of_month.beginning_of_week..month.end_of_month.end_of_week.end_of_day
  end

  def month
    DateTime.strptime(@month, MONTH_FORMAT)
  end

  def weeks
    date_range.group_by { |day| day.strftime('%W') }.keys.map do |week|
      DateTime.strptime(week, "%W")..DateTime.strptime(week, "%W").end_of_week.end_of_day
    end
  end
end
