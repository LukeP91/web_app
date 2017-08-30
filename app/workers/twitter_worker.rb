class TwitterWorker
  include Sidekiq::Worker

  def perform(hashtags)
    last_tweet_id = Tweet.last.tweet_id || 0
    tweets = TwitterWrapper.new.fetch(hashtags, last_tweet_id).each { |tweet| save(tweet) }
  end

  private

  def save(tweet)
    saved_tweet = Tweet.create(user_name: tweet[:user_name], message: tweet[:message], tweet_id: tweet[:tweet_id])
    tweet[:hashtags].each do |hashtag|
      hash_tag = HashTag.find_or_create_by(name: hashtag)
      saved_tweet.hash_tags << hash_tag
    end
  end
end
