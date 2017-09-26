class Admin::HashTagsController < ApplicationController
  def index
    hash_tags = HashTag.in_organization(current_organization)

    render :index, locals: { hash_tags: hash_tags }
  end

  def show
    hash_tag = HashTag.find(params[:id])
    top_most_common_words = MostCommonWords.result_for(
      tweets: hash_tag.tweets,
      organization: current_organization,
      limit: 5
    )
    tweets = hash_tag.tweets.order(tweet_id: :desc).limit(20)

    render :show, locals: { hash_tag: hash_tag, tweets: tweets, most_common_words: most_common_words }
  end
end
