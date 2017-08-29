class CreateTweetsHashTags < ActiveRecord::Migration[5.0]
  def change
    create_table :tweets_hash_tags do |t|
      t.integer :tweet_id, null: false, index: true
      t.integer :hash_tag_id, null: false, index: true
    end
  end
end
