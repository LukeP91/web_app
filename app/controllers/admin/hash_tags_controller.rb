class Admin::HashTagsController < ApplicationController
  def index
    hash_tags = HashTag.in_organization(current_organization)

    render :index, locals: { hash_tags: hash_tags }
  end

  def show
    hash_tag = HashTag.find(params[:id])
    tweets = hash_tag.tweets.order(tweet_id: :desc).limit(20)

    render :show, locals: {hash_tag: hash_tag, tweets: tweets}
  end
end
