class AddSendToFbToTweets < ActiveRecord::Migration[5.0]
  def change
    add_column :tweets, :send_to_fb, :boolean, default: true
  end
end
