class CreateClassrooms < ActiveRecord::Migration[7.2]
  def up
    create_table :classrooms do |t|
      t.integer "user_id"
      t.string "name"
      t.string "course_code"
      t.string "classroom_code"
      t.timestamps
    end
  end

  def down
    drop_table :classrooms
  end
end
