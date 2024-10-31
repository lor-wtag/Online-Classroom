class CreateAssignments < ActiveRecord::Migration[7.2]
  def up
    create_table :assignments do |t|
      t.string :title
      t.text :description
      t.date :due_date
      t.integer :classroom_id
      t.integer :user_id
      t.timestamps
    end
  end

  def down
    drop_table :assignments
  end
end
