class TwitterWrapper
  def initialize
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = Rails.application.secrets.consumer_key
      config.consumer_secret     = Rails.application.secrets.consumer_secret
      config.access_token        = Rails.application.secrets.access_token
      config.access_token_secret = Rails.application.secrets.access_token_secret
    end
  end

  def fetch(hashtags, batch_size)
    search_query = hashtags.join(' ') + ' -rt'
    @client.search(search_query).map do |tweet|
      { user_name: tweet.user.name, message: tweet.full_text, hashtags: tweet_hashtags(tweet) }
    end
  end

  private

  def tweet_hashtags(tweet)
    tweet.full_text.scan(/#\w*/)
  end
end
