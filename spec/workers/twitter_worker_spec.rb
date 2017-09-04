require 'rails_helper'

describe TwitterWorker do
  it 'saves tweets to DB' do
    source = create(:source, name: '#Rails')
    create(:tweet, user_name: 'lp', message: 'message', tweet_id: 1, sources: [source])
    twitter_wrapper = double('TwitterWrapper')
    allow(twitter_wrapper).to receive(:fetch).with('#Rails', 1).and_return(
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

    expect(Tweet.last).to have_attributes(
      user_name: 'luke_pawlik',
      message: 'New blog post is up #rails #ruby',
      tweet_id: '1'
    )

    expect(Tweet.last.hash_tags.pluck(:name)).to match_array %w[ruby rails]
  end

  it 'saves hashtags to DB' do
    source = create(:source, name: '#Rails')
    create(:tweet, user_name: 'lp', message: 'message', tweet_id: 1, sources: [source])
    twitter_wrapper = double('TwitterWrapper')
    allow(twitter_wrapper).to receive(:fetch).with('#Rails', 1).and_return(
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

    expect(HashTag.pluck(:name)).to include('ruby', 'rails')
  end

  it 'associate source with tweet' do
    source = create(:source, name: '#Rails')
    create(:tweet, user_name: 'lp', message: 'message', tweet_id: 1, sources: [source])
    twitter_wrapper = double('TwitterWrapper')
    allow(twitter_wrapper).to receive(:fetch).with('#Rails', 1).and_return(
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

    expect(Tweet.last.sources).to include source
  end

  it 'reuses existing hashtags' do
    source = create(:source, name: '#Rails')
    create(:hash_tag, name: "ruby")
    create(:tweet, user_name: 'lp', message: 'message', tweet_id: 1, sources: [source])
    twitter_wrapper = double('TwitterWrapper')
    allow(twitter_wrapper).to receive(:fetch).with('#Rails', 1).and_return(
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

  it 'returns tweets in batches' do
    source = create(:source, name: '#GameOfThrones')

    VCR.use_cassette 'twitter_first_batch' do
      TwitterWorker.new.perform(source)
      expect(Tweet.order(tweet_id: :desc).first.tweet_id).to eq "904672973105373185"
    end

    VCR.use_cassette 'twitter_second_batch' do
      TwitterWorker.new.perform(source)
      expect(Tweet.order(tweet_id: :desc).first.tweet_id).to eq "904678875912962049"
    end

    expect(Tweet.all.count).to eq 40
  end
end
