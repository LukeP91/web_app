class Tweets::Day
  DATE_FORMAT = '%d.%m.%Y'.freeze

  Tweet = Struct.new(:id, :date, :status)

  def initialize(date, tweets)
    @date = date
    @tweets = tweets
  end

  def title
    @date.strftime(DATE_FORMAT)
  end

  def tweets
    @tweets.map do |tweet|
      Tweet.new(
        tweet.tweet_id,
        tweet.tweet_created_at.strftime(DATE_FORMAT),
        tweet.sent_to_fb
      )
    end
  end

  def formatted
    " Day: #{title}\n#{formatted_tweets}"
  end

  def formatted_tweets
    if tweets.present?
      tweets.map do |tweet|
        "   #{tweet.id} - sent to facebook? #{tweet.status} for #{tweet.date}\n"
      end.join('')
    else
      "   No tweets found for that day\n"
    end
  end
end
