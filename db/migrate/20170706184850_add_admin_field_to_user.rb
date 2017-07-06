class AddAdminFieldToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :admin, :bool, default: false, null: false
  end
end
