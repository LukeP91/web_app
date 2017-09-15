require 'rails_helper'

describe TwitterWorker do
  it 'saves tweets to DB' do
    source = create(:source, name: '#Rails')
    create(:tweet, user_name: 'lp', message: 'message', tweet_id: 1, sources: [source], organization: source.organization)
    twitter_wrapper = double('TwitterWrapper')
    allow(twitter_wrapper).to receive(:fetch).with('#Rails', 1).and_return(
      [
        {
          user_name: 'luke_pawlik',
          message: 'New blog post is up #rails #ruby',
          hashtags: %w[rails ruby],
          tweet_id: '2',
          tweet_created_at: 'Thu Aug 31 07:00:04 +0000 2017'
        }
      ]
    )
    allow(TwitterWrapper).to receive(:new).and_return(twitter_wrapper)

    expect do
      TwitterWorker.new.perform(source.id)
    end.to change { Tweet.count }.by(1)

    expect(Tweet.last).to have_attributes(
      user_name: 'luke_pawlik',
      message: 'New blog post is up #rails #ruby',
      tweet_id: '2',
      tweet_created_at: DateTime.new(2017, 8, 31, 7, 0, 4)
    )

    expect(Tweet.last.hash_tags.pluck(:name)).to match_array %w[ruby rails]
  end

  it 'saves hashtags to DB' do
    source = create(:source, name: '#Rails')
    create(:tweet, user_name: 'lp', message: 'message', tweet_id: 1, sources: [source], organization: source.organization)
    twitter_wrapper = double('TwitterWrapper')
    allow(twitter_wrapper).to receive(:fetch).with('#Rails', 1).and_return(
      [
        {
          user_name: 'luke_pawlik',
          message: 'New blog post is up #rails #ruby',
          hashtags: %w[rails ruby],
          tweet_id: '2'
        }
      ]
    )
    allow(TwitterWrapper).to receive(:new).and_return(twitter_wrapper)

    expect do
      TwitterWorker.new.perform(source.id)
    end.to change { HashTag.count }.by(2)

    expect(HashTag.pluck(:name)).to include('ruby', 'rails')
  end

  it 'associates source with tweet' do
    source = create(:source, name: '#Rails')
    twitter_wrapper = double('TwitterWrapper')
    allow(twitter_wrapper).to receive(:fetch).with('#Rails', 0).and_return(
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

    TwitterWorker.new.perform(source.id)

    expect(Tweet.last.sources).to include source
  end

  it 'reuses existing hashtags' do
    organization = create(:organization, name: 'test_org')
    source = create(:source, name: '#Rails', organization: organization)
    create(:hash_tag, name: 'ruby', organization: organization)
    create(:tweet, user_name: 'lp', message: 'message', tweet_id: '1', sources: [source], organization: organization)
    twitter_wrapper = double('TwitterWrapper')
    allow(twitter_wrapper).to receive(:fetch).with('#Rails', 1).and_return(
      [
        {
          user_name: 'luke_pawlik',
          message: 'New blog post is up #rails #ruby',
          hashtags: %w[rails ruby],
          tweet_id: '2'
        }
      ]
    )
    allow(TwitterWrapper).to receive(:new).and_return(twitter_wrapper)

    expect do
      TwitterWorker.new.perform(source.id)
    end.to change { HashTag.count }.by(1)
  end

  it 'does not use hashtags from other organization' do
    organization = create(:organization)
    source = create(:source, name: '#Rails', organization: organization)
    create(:hash_tag, name: 'rails')
    create(:tweet, user_name: 'lp', message: 'message', tweet_id: '1', sources: [source])
    twitter_wrapper = double('TwitterWrapper')
    allow(twitter_wrapper).to receive(:fetch).with('#Rails', 1).and_return(
      [
        {
          user_name: 'luke_pawlik',
          message: 'New blog post is up #rails',
          hashtags: %w[rails],
          tweet_id: '1'
        }
      ]
    )
    allow(TwitterWrapper).to receive(:new).and_return(twitter_wrapper)

    expect do
      TwitterWorker.new.perform(source.id)
    end.to change { HashTag.in_organization(organization).count }.by(1)
  end

  it 'returns tweets in batches' do
    source = create(:source, name: '#GameOfThrones')
    facebook_wrapper = double('FacebookWrapper')
    allow(FacebookWrapper).to receive(:new).with(source.organization).and_return(facebook_wrapper)
    allow(facebook_wrapper).to receive(:post_on_wall)

    VCR.use_cassette 'twitter_first_batch' do
      TwitterWorker.new.perform(source.id)
      expect(Tweet.order(tweet_id: :desc).first.tweet_id).to eq '904672973105373185'
    end

    VCR.use_cassette 'twitter_second_batch' do
      TwitterWorker.new.perform(source.id)
      expect(Tweet.order(tweet_id: :desc).first.tweet_id).to eq '904678875912962049'
    end

    expect(Tweet.all.count).to eq 40
  end

  it 'posts fetched tweet to facebook' do
    organization = create(:organization, name: 'test', facebook_access_token: 'test1234')
    source = create(:source, name: '#Rails', organization: organization)
    twitter_wrapper = double('TwitterWrapper')
    allow(twitter_wrapper).to receive(:fetch).with('#Rails', 0).and_return(
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
    facebook_wrapper = double('FacebookWrapper')
    allow(FacebookWrapper).to receive(:new).with(organization).and_return(facebook_wrapper)
    allow(facebook_wrapper).to receive(:post_on_wall)

    TwitterWorker.new.perform(source.id)

    expect(facebook_wrapper).to have_received(:post_on_wall).with('New blog post is up #rails #ruby')
  end

  context 'when facebook_access_token is expired' do
    it 'sets tweet as not send' do
      organization = create(:organization, name: 'test', facebook_access_token: 'test1234', facebook_access_token_expired: true)
      source = create(:source, name: '#Rails', organization: organization)
      twitter_wrapper = double('TwitterWrapper')
      allow(twitter_wrapper).to receive(:fetch).with('#Rails', 0).and_return(
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
      facebook_wrapper = double('FacebookWrapper', post_on_wall: :expired_token)
      allow(FacebookWrapper).to receive(:new).with(organization).and_return(facebook_wrapper)

      TwitterWorker.new.perform(source.id)

      expect(Tweet.first.send_to_fb).to eq false
    end
  end
end
