class CreateUsers < ActiveRecord::Migration[7.2]
  def up
    create_table :users do |t|
      t.string :name
      t.string :email
      t.integer :role, default: 2
      t.string :password_digest
      t.timestamps
    end
    add_index :email
  end

  def down
    drop_table :users
  end
end
