class AddTweetIdToTweet < ActiveRecord::Migration[5.0]
  def change
    add_column :tweets, :tweet_id, :integer, index: true, null: false
  end
end
