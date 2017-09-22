require 'rails_helper'

describe TweetsByWeekCollection do
  it 'returns collection of tweets' do
    organization = create(:organization)
    source = create(:source, name: '#test', organization: organization)
    create(
      :tweet,
      tweet_id: '1',
      tweet_created_at: DateTime.new(2017, 8, 31, 7, 0, 4),
      sent_to_fb: true,
      sources: [source],
      organization: organization
    )
    create(
      :tweet,
      tweet_id: '2',
      tweet_created_at: DateTime.new(2017, 7, 31, 7, 0, 4),
      sent_to_fb: true,
      sources: [source],
      organization: organization
    )
    create(
      :tweet,
      tweet_id: '3',
      tweet_created_at: DateTime.new(2017, 8, 24, 7, 0, 4),
      sent_to_fb: true,
      sources: [source],
      organization: organization
    )
    create(
      :tweet,
      tweet_id: '4',
      tweet_created_at: DateTime.new(2017, 8, 25, 7, 0, 4),
      sent_to_fb: false,
      sources: [source],
      organization: organization
    )
    create(
      :tweet,
      tweet_id: '5',
      tweet_created_at: DateTime.new(2017, 8, 25, 7, 0, 4),
      sent_to_fb: true,
      sources: [source],
      organization: organization
    )
    create(
      :tweet,
      tweet_id: '6',
      tweet_created_at: DateTime.new(2017, 9, 3, 23, 59, 59),
      sent_to_fb: true,
      sources: [source],
      organization: organization
    )

    expect(Tweets::Report.new(organization, '08.2017').generate_report).to eq(
      "Week: 31.07.2017 - 06.08.2017\n" \
      " Day: 31.07.2017\n" \
      "   2 - sent to facebook? true for 31.07.2017\n" \
      " Day: 01.08.2017\n" \
      "   No tweets found for that day\n" \
      " Day: 02.08.2017\n" \
      "   No tweets found for that day\n" \
      " Day: 03.08.2017\n" \
      "   No tweets found for that day\n" \
      " Day: 04.08.2017\n" \
      "   No tweets found for that day\n" \
      " Day: 05.08.2017\n" \
      "   No tweets found for that day\n" \
      " Day: 06.08.2017\n" \
      "   No tweets found for that day\n" \
      "Week: 07.08.2017 - 13.08.2017\n" \
      " Day: 07.08.2017\n" \
      "   No tweets found for that day\n" \
      " Day: 08.08.2017\n" \
      "   No tweets found for that day\n" \
      " Day: 09.08.2017\n" \
      "   No tweets found for that day\n" \
      " Day: 10.08.2017\n" \
      "   No tweets found for that day\n" \
      " Day: 11.08.2017\n" \
      "   No tweets found for that day\n" \
      " Day: 12.08.2017\n" \
      "   No tweets found for that day\n" \
      " Day: 13.08.2017\n" \
      "   No tweets found for that day\n" \
      "Week: 14.08.2017 - 20.08.2017\n" \
      " Day: 14.08.2017\n" \
      "   No tweets found for that day\n" \
      " Day: 15.08.2017\n" \
      "   No tweets found for that day\n" \
      " Day: 16.08.2017\n" \
      "   No tweets found for that day\n" \
      " Day: 17.08.2017\n" \
      "   No tweets found for that day\n" \
      " Day: 18.08.2017\n" \
      "   No tweets found for that day\n" \
      " Day: 19.08.2017\n" \
      "   No tweets found for that day\n" \
      " Day: 20.08.2017\n" \
      "   No tweets found for that day\n" \
      "Week: 21.08.2017 - 27.08.2017\n" \
      " Day: 21.08.2017\n" \
      "   No tweets found for that day\n" \
      " Day: 22.08.2017\n" \
      "   No tweets found for that day\n" \
      " Day: 23.08.2017\n" \
      "   No tweets found for that day\n" \
      " Day: 24.08.2017\n" \
      "   3 - sent to facebook? true for 24.08.2017\n" \
      " Day: 25.08.2017\n" \
      "   4 - sent to facebook? false for 25.08.2017\n" \
      "   5 - sent to facebook? true for 25.08.2017\n" \
      " Day: 26.08.2017\n" \
      "   No tweets found for that day\n" \
      " Day: 27.08.2017\n" \
      "   No tweets found for that day\n" \
      "Week: 28.08.2017 - 03.09.2017\n" \
      " Day: 28.08.2017\n" \
      "   No tweets found for that day\n" \
      " Day: 29.08.2017\n" \
      "   No tweets found for that day\n" \
      " Day: 30.08.2017\n" \
      "   No tweets found for that day\n" \
      " Day: 31.08.2017\n" \
      "   1 - sent to facebook? true for 31.08.2017\n" \
      " Day: 01.09.2017\n" \
      "   No tweets found for that day\n" \
      " Day: 02.09.2017\n" \
      "   No tweets found for that day\n" \
      " Day: 03.09.2017\n" \
      "   6 - sent to facebook? true for 03.09.2017\n"
    )
  end
end
