class RemoveUserIdFromAssignments < ActiveRecord::Migration[7.2]
  def up
    remove_column :assignments, :user_id
  end
  def down
    add_column :assignments, :user_id
  end
end
