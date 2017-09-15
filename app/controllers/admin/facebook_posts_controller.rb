class Admin::FacebookPostsController < ApplicationController
  def index
    tweets = Tweet.in_organization(current_organization).not_send_to_facebook
    authorize tweets
    render :index, locals: { tweets: tweets }
  end

  def send_to_facebook
    SendTweetToFacebook.call(user: current_user, tweet_id: params[:id], organization: current_organization)
    respond_to do |format|
      format.js
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_facebook_posts
  end
end
