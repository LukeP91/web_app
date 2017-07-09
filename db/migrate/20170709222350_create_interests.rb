class CreateInterests < ActiveRecord::Migration[5.0]
  def change
    create_table :interests do |t|
      t.integer :user_id, null: false, index: true
      t.string :name,     null: false, index: true
      t.string :category, null: false

      t.timestamps null: false
    end
  end
end
