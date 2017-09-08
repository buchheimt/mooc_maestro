class UserCourses < ActiveRecord::Migration[5.1]
  def change
    create_table :user_courses do |t|
      t.integer :user_id
      t.integer :course_id
      t.datetime :start_date
      t.datetime :end_date
      t.integer :progress
      t.string :notes
      t.string :goal
    end
  end
end
