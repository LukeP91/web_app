class CreateUsersInterests < ActiveRecord::Migration[5.0]
  def change
    create_table :users_interests do |t|
      t.integer :user_id, null: false, index: true
      t.integer :category_id, null: false, index: true
    end
  end
end
