class CreateCategory < ActiveRecord::Migration[5.0]
  def change
    create_table :categories do |t|
      t.string :name, null: false, index: true
    end

    add_column :interests, :category_id, :integer, index: true
    remove_column :interests, :user_id, :integer, index: true
    remove_column :interests, :category
  end
end
