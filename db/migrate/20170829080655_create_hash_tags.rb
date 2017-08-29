class CreateHashTags < ActiveRecord::Migration[5.0]
  def change
    create_table :hash_tags do |t|
      t.string :name
    end
  end
end
