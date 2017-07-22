class CreateOrganization < ActiveRecord::Migration[5.0]
  def change
    create_table :organizations do |t|
      t.string :name,      null: false, index: true
      t.string :subdomain, null: false, index: true
    end

    add_column :users, :organization_id, :integer, null: false, default: 1
  end
end
