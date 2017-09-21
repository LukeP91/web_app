class Tweets::Day
  include Enumerable
  DATE_FORMAT = '%d.%m.%Y'.freeze

  Tweet = Struct.new(:id, :date, :status)

  def initialize(date, tweets)
    @date = date
    @tweets = tweets
  end

  def title
    @date.strftime(DATE_FORMAT).to_s
  end

  def each
    tweets.each do |tweet|
      yield tweet
    end
  end

  private

  def tweets
    @tweets.map do |tweet|
      Tweet.new(
        tweet.tweet_id,
        tweet.tweet_created_at.strftime(DATE_FORMAT),
        tweet.sent_to_fb
      )
    end
  end
end
