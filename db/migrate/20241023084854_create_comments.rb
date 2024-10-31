class CreateComments < ActiveRecord::Migration[7.2]
  def up
    create_table :comments do |t|
      t.text :content
      t.integer :user_id
      t.integer :commentable_id
      t.string :commentable_type

      t.timestamps
    end
  end

  def down
    drop_table :comments
  end
end
