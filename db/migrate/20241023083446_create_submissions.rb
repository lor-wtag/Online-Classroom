class CreateSubmissions < ActiveRecord::Migration[7.2]
  def up
    create_table :submissions do |t|
      t.integer :assignment_id
      t.integer :user_id
      t.string :file
      t.decimal :grade
      t.text :feedback
      t.datetime :graded_at

      t.timestamps
    end
  end

  def down
    drop_table :submissions
  end
end
