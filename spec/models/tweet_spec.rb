require 'rails_helper'

describe Tweet do
  describe '.most_common_words' do
    it 'returns sorted array with unified most common words' do
      organization = create(:organization)
      source = create(:source, organization: organization)
      create(:tweet, user_name: 'lp', message: 'first tweet #Ruby', tweet_id: '1', sources: [source])
      create(:tweet, user_name: 'lp', message: 'third Tweet #Rubys #Rails', tweet_id: '3', sources: [source])
      create(:tweet, user_name: 'lp', message: "fourth! tweet's #Rails", tweet_id: '4', sources: [source])
      create(:tweet, user_name: 'lp', message: "fourth? tweets #Rails", tweet_id: '4', sources: [source])

      expect(Tweet.most_common_words(organization)).to eq(
        [
          ["tweet", 4],
          ["rail", 3],
          ["fourth", 2],
          ["ruby", 2],
          ["third", 1],
          ["first", 1]
        ]
      )
    end
  end
end
