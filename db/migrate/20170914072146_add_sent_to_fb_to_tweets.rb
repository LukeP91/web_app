class AddSentToFbToTweets < ActiveRecord::Migration[5.0]
  def change
    add_column :tweets, :sent_to_fb, :boolean, default: true
  end
end
