require 'rails_helper'

describe TweetsCollection do
  it 'returns collection of tweets' do
    organization = create(:organization)
    source = create(:source, name: '#test', organization: organization)
    create(
      :tweet,
      user_name: 'lp',
      message: 'first tweet #test',
      tweet_id: '1',
      tweet_created_at: DateTime.new(2017, 8, 31, 7, 0, 4),
      sent_to_fb: true,
      sources: [source],
      organization: organization
    )
    create(
      :tweet,
      user_name: 'lp',
      message: 'second tweet #test',
      tweet_id: '2',
      tweet_created_at: DateTime.new(2017, 7, 31, 7, 0, 4),
      sent_to_fb: true,
      sources: [source],
      organization: organization
    )
    create(
      :tweet,
      user_name: 'lp',
      message: 'thrid tweet #test',
      tweet_id: '3',
      tweet_created_at: DateTime.new(2017, 8, 24, 7, 0, 4),
      sent_to_fb: true,
      sources: [source],
      organization: organization
    )
    create(
      :tweet,
      user_name: 'lp',
      message: 'fourth tweet #test',
      tweet_id: '4',
      tweet_created_at: DateTime.new(2017, 8, 25, 7, 0, 4),
      sent_to_fb: false,
      sources: [source],
      organization: organization
    )
    create(
      :tweet,
      user_name: 'lp',
      message: 'fifth tweet #test',
      tweet_id: '5',
      tweet_created_at: DateTime.new(2017, 8, 25, 7, 0, 4),
      sent_to_fb: true,
      sources: [source],
      organization: organization
    )

    tweets = TweetsForMonth.call(organization: organization, date: '21/08/2017')
    test = ''
    TweetsCollection.new(tweets).each do |week|
      test << "Week: #{week.title}\n"
      week.each do |day|
        test << "Day: #{day.title}\n"
        day.each do |tweet|
          test << "#{tweet.id} - sent to facebook? #{tweet.status} for #{tweet.date}\n"
        end
      end
    end

    expect(test).to eq (
      "Week: 21.08.2017 - 27.08.2017\n" \
      "Day: 24.08.2017\n" \
      "3 - sent to facebook? true for 24.08.2017\n" \
      "Day: 25.08.2017\n" \
      "4 - sent to facebook? false for 25.08.2017\n" \
      "5 - sent to facebook? true for 25.08.2017\n" \
      "Week: 28.08.2017 - 03.09.2017\n" \
      "Day: 31.08.2017\n" \
      "1 - sent to facebook? true for 31.08.2017\n"
    )
  end
end
