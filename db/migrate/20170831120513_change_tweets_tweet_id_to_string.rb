class ChangeTweetsTweetIdToString < ActiveRecord::Migration[5.0]
  def change
    change_column :tweets, :tweet_id, :string
  end
end
