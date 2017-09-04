require 'rails_helper'

describe MostCommonWords do
  describe '.result_for' do
    it 'returns sorted array with unified most common words' do
      organization = create(:organization)
      source = create(:source, organization: organization)
      create(:tweet, user_name: 'lp', message: 'first tweet #Ruby', tweet_id: '1', sources: [source])
      create(:tweet, user_name: 'lp', message: "O'Reilly Tweet #Ruby #Rails", tweet_id: '3', sources: [source])
      create(:tweet, user_name: 'lp', message: "fourth! tweet's #Rails", tweet_id: '4', sources: [source])
      create(:tweet, user_name: 'lp', message: "fourth? tweets?! #Rails", tweet_id: '4', sources: [source])

      expect(MostCommonWords.result_for(organization: organization)).to eq(
        [
          ["rails", 3],
          ["tweet", 3],
          ["fourth", 2],
          ["ruby", 2],
          ["first", 1],
          ["oreilly", 1],
          ["tweets", 1]
        ]
      )
    end
  end
end
