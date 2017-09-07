require 'rails_helper'

describe User do
  describe 'validates uniqueness of tweet in organization' do
    context 'when new tweet has the same tweet_id as already existing' do
      it 'adds validation error' do
        organization = create(:organization, name: 'Umbrella Corporation')
        source = create(:source, name: '#zombie', organization: organization)
        hashtag = create(:hash_tag, name: '#zombie', organization: organization)
        create(
          :tweet,
          user_name: 'ada_wong',
          message: 'Zombies are here #zombie',
          tweet_id: '1',
          sources: [source],
          hash_tags: [hashtag],
          organization: organization
        )
        invalid_tweet = Tweet.new(
          user_name: 'ada_wong',
          message: 'Zombies are here #zombie',
          tweet_id: '1',
          sources: [source],
          hash_tags: [hashtag],
          organization: organization
        )
        invalid_tweet.valid?

        expect(invalid_tweet.errors[:tweet_id]).to include 'has already been taken'
      end
    end
  end
end
