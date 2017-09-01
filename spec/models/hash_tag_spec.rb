require 'rails_helper'

describe HashTag do
  describe '.tweets_per_hashtag' do
    it 'returns hash with tweets count per hashtag' do
      rails = create(:hash_tag, name: 'rails')
      ruby = create(:hash_tag, name: 'ruby')
      organization = create(:organization)
      source = create(:source, organization: organization)
      create(:tweet, user_name: 'lp', message: 'first tweet #Ruby', hash_tags: [ruby], tweet_id: '1', sources: [source])
      create(:tweet, user_name: 'lp', message: 'third tweet #Ruby', hash_tags: [ruby], tweet_id: '3', sources: [source])
      create(:tweet, user_name: 'lp', message: 'fourth tweet #Rails', hash_tags: [rails], tweet_id: '4', sources: [source])

      expect(HashTag.tweets_count_per_hashtag(organization)).to eq(ruby: 2, rails: 1)
    end

    context 'when tweet has multiple hashtags' do
      it 'counts for both of hashtags' do
        rails = create(:hash_tag, name: 'Rails')
        ruby = create(:hash_tag, name: 'Ruby')
        organization = create(:organization)
        source = create(:source, organization: organization)
        create(:tweet, user_name: 'lp', message: 'second tweet #Ruby #Rails', hash_tags: [ruby, rails], tweet_id: '2', sources: [source])

        expect(HashTag.tweets_count_per_hashtag(Organization.first)).to eq(ruby: 1, rails: 1)
      end
    end
  end
end
