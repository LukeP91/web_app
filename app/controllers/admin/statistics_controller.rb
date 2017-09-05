class Admin::StatisticsController < ApplicationController
  def show
    most_common_words = MostCommonWords.result_for(organization: current_organization, limit: 20)
    tweets_count_per_hashtag = TweetsCountPerHashtag.result_for(organization: current_organization)
    render :show, locals: { most_common_words: most_common_words, tweets_count_per_hashtag: tweets_count_per_hashtag }
  end
end
