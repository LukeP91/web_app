class TwitterWrapper
  def initialize
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key = Rails.application.secrets.consumer_key
      config.consumer_secret = Rails.application.secrets.consumer_secret
      config.access_token = Rails.application.secrets.access_token
      config.access_token_secret = Rails.application.secrets.access_token_secret
    end
    @tweet_count = 20
  end


  def fetch(hashtag, last_tweet_id)
    @client.search(
      "#{hashtag} -rt",
      count: @tweet_count,
      since_id: last_tweet_id,
      result_type: 'recent'
    ).attrs[:statuses].map do |tweet|
      tweet_data(tweet)
    end
  end

  private

  def tweet_data(tweet)
    {
      user_name: tweet[:user][:name],
      message: tweet[:text],
      hashtags: hashtags(tweet),
      tweet_id: tweet[:id].to_s
    }
  end

  def hashtags(tweet)
    tweet[:entities][:hashtags].map { |hashtag| hashtag[:text] }
  end
end
