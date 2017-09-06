class TwitterWorker
  include Sidekiq::Worker

  def perform(source_id)
    @source = Source.find(source_id)
    tweets = TwitterWrapper.new.fetch(@source.name, last_tweet_id).each { |tweet| save(tweet) }
  end

  private

  def save(tweet)
    saved_tweet = @source.tweets.create(
      user_name: tweet[:user_name],
      message: tweet[:message],
      tweet_id: tweet[:tweet_id],
      tweet_created_at: tweet[:tweet_created_at]
    )

    tweet[:hashtags].each do |hashtag|
      hash_tag = @source.organization.hash_tags.find_or_create_by(name: hashtag)
      saved_tweet.hash_tags << hash_tag
    end
  end

  def last_tweet_id
    if @source.tweets.any?
      @source.tweets.order(tweet_id: :desc).first.tweet_id.to_i
    else
      0
    end
  end
end
