require 'rails_helper'

describe TwitterWrapper do
  describe '#fetch?' do
    it 'returns array of tweets' do
      client = double('TwitterClient')
      tweet = double('Tweets')
      tweets = [tweet, tweet]
      allow(tweet).to receive(:full_text).and_return('First tweet #Ruby, #Rails', 'Second tweet #Ruby, #Rails')
      allow(tweet).to receive_message_chain('user.name').and_return('luke_pawlik')
      allow(tweet).to receive(:id).and_return(1, 2)
      allow(client).to receive(:search).with('Ruby Rails -rt').and_return(tweets)
      allow(Twitter::REST::Client).to receive(:new).and_return(client)

      expect(TwitterWrapper.new.fetch(%w[Ruby Rails], 20)).to match_array(
        [
          { user_name: 'luke_pawlik', message: 'First tweet #Ruby, #Rails', hashtags: %w[#Ruby #Rails], tweet_id: 1 },
          { user_name: 'luke_pawlik', message: 'Second tweet #Ruby, #Rails', hashtags: %w[#Ruby #Rails], tweet_id: 2 }
        ]
      )
    end
  end
end
