require 'rails_helper'

describe TwitterWrapper do
  describe '#fetch' do
    it 'returns array of tweets' do
      VCR.use_cassette 'twitter_search_response' do
        expect(TwitterWrapper.fetch('#Rails', 1)).to include(
          user_name: 'Rails Links',
          message: 'Announcing the Modularized AWS SDK for Ruby (Version 3) | Amazon Web Services #ruby #rails https://t.co/M9qoPT0sxd',
          hashtags: %w[#ruby #rails],
          tweet_id: '903150378962825216',
          tweet_created_at: 'Thu Aug 31 07:00:04 +0000 2017'
        )
      end
    end

    it 'returns only 20 tweets at once' do
      VCR.use_cassette 'twitter_search_response' do
        expect(TwitterWrapper.fetch('#Rails', 1).count).to eq(20)
      end
    end
  end
end
