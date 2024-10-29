class AddIndexToUsers < ActiveRecord::Migration[7.2]
  def up
    add_index :users, :email, unique: true
    add_index :users, :role unless index_exists?(:users, :role)
  end

  def down
    remove_index :users, :email
    remove_index :users, :role if index_exists?(:users, :role)
  end
end
