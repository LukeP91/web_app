require 'rails_helper'

describe MostCommonWords do
  describe '.result_for' do
    it 'returns sorted array with unified most common words' do
      organization = create(:organization)
      source = create(:source, organization: organization)
      create(:tweet, user_name: 'lp', message: 'first tweet #Ruby', tweet_id: '1', sources: [source])
      create(:tweet, user_name: 'lp', message: "O'Reilly Tweet #Ruby #Rails", tweet_id: '3', sources: [source])
      create(:tweet, user_name: 'lp', message: "fourth's! tweet's #Rails", tweet_id: '4', sources: [source])
      create(:tweet, user_name: 'lp', message: 'fourth? tweets?! #Rails', tweet_id: '4', sources: [source])

      expect(MostCommonWords.result_for(organization: organization, limit: 10)).to eq(
        [
          ['rails', 3],
          ['tweet', 3],
          ['fourth', 2],
          ['ruby', 2],
          ['first', 1],
          ['oreilly', 1],
          ['tweets', 1]
        ]
      )
    end

    it 'drops words shorter than 3 chars' do
      organization = create(:organization)
      source = create(:source, organization: organization)
      create(:tweet, user_name: 'lp', message: 'That and it', tweet_id: '1', sources: [source])

      expect(MostCommonWords.result_for(organization: organization, limit: 10)).to eq(
        [
          ['and', 1],
          ['that', 1]
        ]
      )
    end

    it 'limits top words to amount passed by limit option' do
      organization = create(:organization)
      source = create(:source, organization: organization)
      create(:tweet, user_name: 'lp', message: 'first tweet #Ruby', tweet_id: '1', sources: [source])
      create(:tweet, user_name: 'lp', message: "O'Reilly Tweet #Ruby #Rails", tweet_id: '3', sources: [source])
      create(:tweet, user_name: 'lp', message: "fourth's! tweet's #Rails", tweet_id: '4', sources: [source])
      create(:tweet, user_name: 'lp', message: 'fourth? tweets?! #Rails', tweet_id: '4', sources: [source])

      expect(MostCommonWords.result_for(organization: organization, limit: 3)).to eq(
        [
          ['rails', 3],
          ['tweet', 3],
          ['fourth', 2]
        ]
      )
    end

    context 'when hashtags parameter is provided' do
      it 'returns words count only for those hashtags' do
        organization = create(:organization)
        source = create(:source, organization: organization)
        ruby = create(:hash_tag, name: '#ruby', organization: organization)
        rails = create(:hash_tag, name: '#rails', organization: organization)
        create(:tweet, user_name: 'lp', message: 'first tweet #Ruby', tweet_id: '1', sources: [source], hash_tags: [ruby, rails])
        create(:tweet, user_name: 'lp', message: "O'Reilly Tweet #Ruby #Rails", tweet_id: '3', sources: [source], hash_tags: [ruby])
        create(:tweet, user_name: 'lp', message: "fourth's! tweet's #Rails", tweet_id: '4', sources: [source], hash_tags: [rails])

        tweets = HashTag.find(ruby.id).tweets

        expect(MostCommonWords.result_for(tweets: tweets, organization: organization, limit: 10)).to eq(
        [
          ['ruby', 2],
          ['tweet', 2],
          ['first', 1],
          ['oreilly', 1],
          ['rails', 1]
        ]
      )
      end
    end
  end
end
