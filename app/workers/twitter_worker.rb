class TwitterWorker
  include Sidekiq::Worker

  def perform(hashtags, batch_size=20)
    tweets = TwitterWrapper.new.fetch(hashtags, batch_size)
    save_to_databse(tweets)
  end

  private

  def save_to_databse(tweets)
    tweets.each do |tweet|
      user = Tweet.create(user_name: tweet[:user_name], message: tweet[:message])
      tweet[:hashtags].each do |hashtag|
        hash_tag = HashTag.find_or_create_by(name: hashtag)
        user.hash_tags << hash_tag
      end
    end
  end
end
