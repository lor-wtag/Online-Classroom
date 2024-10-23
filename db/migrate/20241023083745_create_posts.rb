class CreatePosts < ActiveRecord::Migration[7.2]
  def up
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.integer :user_id
      t.integer :classroom_id

      t.timestamps
    end
  end

  def down
    drop_table :posts
  end
end
