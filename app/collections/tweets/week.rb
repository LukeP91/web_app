class Tweets::Week
  include Enumerable

  DATE_FORMAT = '%d.%m.%Y'.freeze

  def initialize(date_range, tweets)
    @date_range = date_range
    @tweets = tweets
  end

  def title
    "#{date_range.first.strftime(DATE_FORMAT)} - #{date_range.last.strftime(DATE_FORMAT)}"
  end

  def each
    days_with_tweets.each do |day|
      yield day.title, day
    end
  end

  private

  attr_reader :date_range, :tweets

  def days_with_tweets
    @days_with_tweets ||= days.map do |day|
      scoped_tweets = tweets.where(tweet_created_at: day)
      Tweets::Day.new(day, scoped_tweets)
    end
  end

  def days
    tweets.order(:tweet_created_at).pluck(:tweet_created_at).uniq
  end
end
