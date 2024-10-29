class AddRoleIndexToUsers < ActiveRecord::Migration[7.2]
  def up
    add_index :users, :role
  end

  def down
    remove_index :users, :role
  end
end
