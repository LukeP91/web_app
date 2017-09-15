class Admin::FacebookPostsController < ApplicationController
  def index
    tweets = Tweet.in_organization(current_organization).not_send_to_facebook
    authorize tweets
    render :index, locals: { tweets: tweets }
  end

  def send_to_facebook
    tweet = Tweet.in_organization(current_organization).find(params[:id])
    authorize tweet
    SendTweetToFacebook.call(tweet: tweet, organization: current_organization)
    respond_to do |format|
      format.js
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_facebook_posts
  end
end
