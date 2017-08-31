require 'rails_helper'

describe TwitterWorker do
  it 'saves tweets to DB' do
    source = create(:source, name: '#Rails')
    last_tweet = double('LastTweet', tweet_id: 1)
    allow(Tweet).to receive(:last).and_return(last_tweet)
    twitter_wrapper = double('TwitterWrapper', fetch:
      [
        {
          user_name: 'luke_pawlik',
          message: 'New blog post is up #rails #ruby',
          hashtags: %w[rails ruby],
          tweet_id: '1'
        }
      ]
    )
    allow(TwitterWrapper).to receive(:new).and_return(twitter_wrapper)

    expect do
      TwitterWorker.new.perform(source)
    end.to change { Tweet.count }.by(1)

    expect(Tweet.first).to have_attributes(
      user_name: 'luke_pawlik',
      message: 'New blog post is up #rails #ruby',
      tweet_id: '1'
    )

    expect(Tweet.first.hash_tags.pluck(:name)).to match_array %w[ruby rails]
  end

  it 'saves hashtags to DB' do
    source = create(:source, name: 'Source')
    last_tweet = double('LastTweet', tweet_id: 1)
    allow(Tweet).to receive(:last).and_return(last_tweet)
    twitter_wrapper = double('TwitterWrapper', fetch:
      [
        {
          user_name: 'luke_pawlik',
          message: 'New blog post is up #rails #ruby',
          hashtags: %w[rails ruby],
          tweet_id: '1'
        }
      ]
    )
    allow(TwitterWrapper).to receive(:new).and_return(twitter_wrapper)

    expect do
      TwitterWorker.new.perform(source)
    end.to change { HashTag.count }.by(2)

    expect(HashTag.pluck(:name)).to match_array %w[ruby rails]
  end

  it 'associate source with tweet' do
    source = create(:source, name: '#Rails')
    last_tweet = double('LastTweet', tweet_id: 1)
    allow(Tweet).to receive(:last).and_return(last_tweet)
    twitter_wrapper = double('TwitterWrapper', fetch:
      [
        {
          user_name: 'luke_pawlik',
          message: 'New blog post is up #rails #ruby',
          hashtags: %w[rails ruby],
          tweet_id: '1'
        }
      ]
    )
    allow(TwitterWrapper).to receive(:new).and_return(twitter_wrapper)

    TwitterWorker.new.perform(source)

    expect(Tweet.first.sources).to include source
  end

  it 'reuses existing hashtags' do
    source = create(:source, name: '#Rails')
    create(:hash_tag, name: "ruby")
    last_tweet = double('LastTweet', tweet_id: 1)
    allow(Tweet).to receive(:last).and_return(last_tweet)
    twitter_wrapper = double('TwitterWrapper', fetch:
      [
        {
          user_name: 'luke_pawlik',
          message: 'New blog post is up #rails #ruby',
          hashtags: %w[rails ruby],
          tweet_id: '1'
        }
      ]
    )
    allow(TwitterWrapper).to receive(:new).and_return(twitter_wrapper)

    expect do
      TwitterWorker.new.perform(source)
    end.to change { HashTag.count }.by(1)
  end
end
