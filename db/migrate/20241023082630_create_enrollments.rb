class CreateEnrollments < ActiveRecord::Migration[7.2]
  def up
    create_table :enrollments do |t|
      t.integer :user_id
      t.integer :classroom_id

      t.timestamps
    end
    add_index("enrollments", [ "user_id", "classroom_id" ])
  end

  def down
    drop_table :enrollments
  end
end
