class TwitterWrapper
  def initialize
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = Rails.application.secrets.consumer_key
      config.consumer_secret     = Rails.application.secrets.consumer_secret
      config.access_token        = Rails.application.secrets.access_token
      config.access_token_secret = Rails.application.secrets.access_token_secret
    end
    @tweet_count = 20
  end

  def fetch(hashtags, last_tweet_id)
    search_query = hashtags.join(' OR ') + ' -rt'
    @client.search(search_query, count: @tweet_count, since_id: last_tweet_id, result_type: 'recent').map do |tweet|
      { user_name: tweet.user.name, message: tweet.full_text, hashtags: tweet.hashtags.map(&:text), tweet_id: tweet.id }
    end
  end
end
