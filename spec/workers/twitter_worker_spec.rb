require 'rails_helper'

describe TwitterWorker do
  it 'saves tweets to DB' do
    last_tweet = double("LastTweet")
    tweet = { user_name: 'luke_pawlik', message: 'New blog post is up. #Ruby #Rails', hashtags: %w[Ruby Rails], tweet_id: 1 }
    twitter_wrapper = instance_double('TwitterWrapper')
    allow(TwitterWrapper).to receive(:new).and_return(twitter_wrapper)
    allow(twitter_wrapper).to receive(:fetch).with(['Ruby'], 1).and_return([tweet])
    allow(Tweet).to receive(:last).and_return(last_tweet)
    allow(last_tweet).to receive(:tweet_id).and_return(1)

    expect{
      TwitterWorker.new.perform(['Ruby'])
    }.to change { Tweet.count }.by(1)

    expect(Tweet.first).to have_attributes(
      user_name: 'luke_pawlik',
      message: 'New blog post is up. #Ruby #Rails',
      tweet_id: 1
    )
  end

  it 'saves hashtags to DB' do
    last_tweet = double("LastTweet")
    tweet = { user_name: 'luke_pawlik', message: 'New blog post is up. #Ruby #Rails', hashtags: %w[Ruby Rails], tweet_id: 1 }
    twitter_wrapper = instance_double('TwitterWrapper')
    allow(TwitterWrapper).to receive(:new).and_return(twitter_wrapper)
    allow(twitter_wrapper).to receive(:fetch).with(['Ruby'], 1).and_return([tweet])
    allow(Tweet).to receive(:last).and_return(last_tweet)
    allow(last_tweet).to receive(:tweet_id).and_return(1)

    expect{
      TwitterWorker.new.perform(['Ruby'])
    }.to change { HashTag.count }.by(2)

    expect(HashTag.pluck(:name)).to match_array %w[Ruby Rails]
  end

  it 'associate hashtags with tweet' do
    last_tweet = double("LastTweet")
    tweet = { user_name: 'luke_pawlik', message: 'New blog post is up. #Ruby #Rails', hashtags: %w[Ruby Rails], tweet_id: 1 }
    twitter_wrapper = instance_double('TwitterWrapper')
    allow(TwitterWrapper).to receive(:new).and_return(twitter_wrapper)
    allow(twitter_wrapper).to receive(:fetch).with(['Ruby'], 1).and_return([tweet])
    allow(Tweet).to receive(:last).and_return(last_tweet)
    allow(last_tweet).to receive(:tweet_id).and_return(1)

    TwitterWorker.new.perform(['Ruby'])

    expect(Tweet.first.hash_tags.pluck(:name)).to match_array ['Ruby', 'Rails']
  end

  it 'reuses existing hashtags' do
    create(:hash_tag, name: 'Ruby')
    last_tweet = double("LastTweet")
    tweet = { user_name: 'luke_pawlik', message: 'New blog post is up. #Ruby #Rails', hashtags: %w[Ruby Rails], tweet_id: 1 }
    twitter_wrapper = instance_double('TwitterWrapper')
    allow(TwitterWrapper).to receive(:new).and_return(twitter_wrapper)
    allow(twitter_wrapper).to receive(:fetch).with(['Ruby'], 1).and_return([tweet])
    allow(Tweet).to receive(:last).and_return(last_tweet)
    allow(last_tweet).to receive(:tweet_id).and_return(1)

    expect{
      TwitterWorker.new.perform(['Ruby'])
    }.to change { HashTag.count }.by(1)

    expect(HashTag.pluck(:name)).to match_array %w[Ruby Rails]
  end
end
