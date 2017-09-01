require 'rails_helper'

describe Tweet do
  describe '.most_common_words' do
    it 'returns sorted array with most common words' do
      organization = create(:organization)
      source = create(:source, organization: organization)
      create(:tweet, user_name: 'lp', message: 'first tweet #Ruby', tweet_id: '1', sources: [source])
      create(:tweet, user_name: 'lp', message: 'third tweet #Ruby', tweet_id: '3', sources: [source])
      create(:tweet, user_name: 'lp', message: 'fourth tweet #Rails', tweet_id: '4', sources: [source])

      expect(Tweet.most_common_words(organization)).to eq(
        [
          ["tweet", 3],
          ["#Ruby", 2],
          ["#Rails", 1],
          ["fourth", 1],
          ["third", 1],
          ["first", 1]
        ]
      )
    end
  end
end
