class TwitterWorker
  include Sidekiq::Worker

  def perform(source_id)
    @source = Source.find(source_id)
    TwitterWrapper.fetch(source.name, last_tweet_id).each { |tweet| save(tweet) }
  end

  private

  attr_reader :source, :tweet

  def save(tweet_params)
    @tweet = Tweet.new
    tweet_form = TweetForm.new(tweet, tweet_params).as(source)
    tweet_form.save
    if tweet_form.persisted?
      ActionCable.server.broadcast 'tweets',
        user_name: @tweet.user_name,
        message: @tweet.message,
        tweet_id: @tweet.tweet_id,
        tweet_created_at: @tweet.tweet_created_at&.strftime("%T %d-%m-%Y") || "",
        hash_tags_ids: @tweet.hash_tags.pluck(:id)
      post_on_facebook!
    end
  end

  def last_tweet_id
    source.tweets.order(tweet_id: :desc).first&.tweet_id.to_i
  end

  def post_on_facebook!
    post_response = FacebookWrapper.new(source.organization).post_on_wall(tweet.message)
    tweet.update_attributes(sent_to_fb: post_response == :ok)
  end
end
