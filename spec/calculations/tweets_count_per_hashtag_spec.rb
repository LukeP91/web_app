require 'rails_helper'

describe TweetsCountPerHashtag do
  describe '.result_for' do
    it 'returns sorted array of hashtags with tweets count for each hashtag within organization' do
      organization = create(:organization)
      rails = create(:hash_tag, name: '#rails', organization: organization)
      rails_outside_organization = create(:hash_tag, name: 'rails')
      ruby = create(:hash_tag, name: '#ruby', organization: organization)
      source = create(:source, organization: organization)
      create(:tweet, user_name: 'lp', message: 'first tweet #Ruby', hash_tags: [ruby], tweet_id: '1', sources: [source])
      create(:tweet, user_name: 'lp', message: 'third tweet #Ruby', hash_tags: [ruby], tweet_id: '3', sources: [source])
      create(:tweet, user_name: 'lp', message: 'fourth tweet #Rails', hash_tags: [rails], tweet_id: '4', sources: [source])
      create(:tweet, user_name: 'lp', message: 'fourth tweet #Rails', hash_tags: [rails_outside_organization], tweet_id: '5')

      expect(TweetsCountPerHashtag.result_for(organization: organization, limit: 3)).to eq(
        [
          { name: '#ruby', count: 2 },
          { name: '#rails', count: 1 }
        ]
      )
    end

    it 'limits amount of hashtags to specified limit' do
      organization = create(:organization)
      rails = create(:hash_tag, name: '#rails', organization: organization)
      ruby = create(:hash_tag, name: '#ruby', organization: organization)
      js = create(:hash_tag, name: '#js', organization: organization)
      source = create(:source, organization: organization)
      create(:tweet, user_name: 'lp', message: 'first tweet #Ruby', hash_tags: [ruby, js], tweet_id: '1', sources: [source])
      create(:tweet, user_name: 'lp', message: 'third tweet #Ruby', hash_tags: [ruby, rails], tweet_id: '3', sources: [source])
      create(:tweet, user_name: 'lp', message: 'fourth tweet #Rails', hash_tags: [rails], tweet_id: '4', sources: [source])
      create(:tweet, user_name: 'lp', message: 'fourth tweet #Rails', hash_tags: [rails], tweet_id: '5')

      expect(TweetsCountPerHashtag.result_for(organization: organization, limit: 2)).to eq(
        [
          { name: '#rails', count: 3 },
          { name: '#ruby', count: 2 }
        ]
      )
    end

    context 'when tweet has multiple hashtags' do
      it 'counts for both of hashtags' do
        organization = create(:organization)
        rails = create(:hash_tag, name: '#rails', organization: organization)
        ruby = create(:hash_tag, name: '#ruby', organization: organization)
        source = create(:source, organization: organization)
        create(:tweet, user_name: 'lp', message: 'second tweet #Ruby #Rails', hash_tags: [ruby, rails], tweet_id: '2', sources: [source])

        expect(TweetsCountPerHashtag.result_for(organization: organization, limit: 2)).to eq(
          [
            { name: '#rails', count: 1 },
            { name: '#ruby', count: 1 }
          ]
        )
      end
    end
  end
end
