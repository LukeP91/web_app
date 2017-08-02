class AddOrganizationIdToCategoryAndInterest < ActiveRecord::Migration[5.0]
  def change
    add_column :interests, :organization_id, :integer, index: true, null: false
    add_column :categories, :organization_id, :integer, index: true, null: false
  end
end
