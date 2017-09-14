class Admin::FacebookPostsController < ApplicationController
  def index
    tweets = Tweet.in_organization(current_organization).not_send_to_facebook
    authorize tweets
    render :index, locals: { tweets: tweets }
  end

  def send_to_facebook
    tweet = Tweet.in_organization(current_organization).find(params[:id])
    authorize tweet
    response = FacebookWrapper.new(current_organization).post_on_wall(tweet.message)
    if response == :ok
      tweet.update_attributes(send_to_fb: true)
    end
    respond_to do |format|
      format.js
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_facebook_posts
  end
end
