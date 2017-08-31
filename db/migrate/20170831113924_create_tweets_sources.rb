class CreateTweetsSources < ActiveRecord::Migration[5.0]
  def change
    create_table :tweets_sources do |t|
      t.integer :tweet_id
      t.integer :source_id
    end
  end
end
