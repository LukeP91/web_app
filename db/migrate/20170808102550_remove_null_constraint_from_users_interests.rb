class RemoveNullConstraintFromUsersInterests < ActiveRecord::Migration[5.0]
  def change
    change_column_null(:users_interests, :user_id, true)
    change_column_null(:users_interests, :interest_id, true)
  end
end
