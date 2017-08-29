require 'rails_helper'

describe TwitterWrapper do
  describe '#fetch?' do
    it 'returns array of tweets' do
      Hashtag = Struct.new(:text)
      client = double('TwitterClient')
      tweet = double('Tweets')
      allow(tweet).to receive(:full_text).and_return('First tweet #Ruby, #Rails', 'Second tweet #Ruby, #Rails')
      allow(tweet).to receive_message_chain('user.name').and_return('luke_pawlik')
      allow(tweet).to receive(:id).and_return(1, 2)
      allow(tweet).to receive(:hashtags).and_return([Hashtag.new('Ruby'), Hashtag.new('Rails')])
      allow(client).to receive(:search).with('Ruby OR Rails -rt', count: 20, since_id: 1, result_type: 'recent')
        .and_return([tweet, tweet])
      allow(Twitter::REST::Client).to receive(:new).and_return(client)

      expect(TwitterWrapper.new.fetch(%w[Ruby Rails], 1)).to match_array(
        [
          { user_name: 'luke_pawlik', message: 'First tweet #Ruby, #Rails', hashtags: %w[Ruby Rails], tweet_id: 1 },
          { user_name: 'luke_pawlik', message: 'Second tweet #Ruby, #Rails', hashtags: %w[Ruby Rails], tweet_id: 2 }
        ]
      )
    end
  end
end

