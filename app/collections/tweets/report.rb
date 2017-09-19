class Tweets::Report
  def initialize(tweets_by_week)
    @tweets_by_week = tweets_by_week
  end

  def generate_report
    report = ''
    @tweets_by_week.each do |week|
      report << "Week: #{week.title}\n"
      week.each do |day_title, tweets|
        report << " Day: #{day_title}\n"
        tweets.each do |tweet|
          report << "   #{tweet.id} - sent to facebook? #{tweet.status} for #{tweet.date}\n"
        end
      end
    end
    report
  end
end
