class AddTweetsCountToHashTag < ActiveRecord::Migration[5.0]
  def change
    add_column :hash_tags, :tweets_count, :integer
  end
end
