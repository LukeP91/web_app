class AddOrganizationReferenceToTweet < ActiveRecord::Migration[5.0]
  def change
    add_column :tweets, :organization_id, :integer, index: true
    add_index :tweets, %i[organization_id tweet_id], unique: true
  end
end
