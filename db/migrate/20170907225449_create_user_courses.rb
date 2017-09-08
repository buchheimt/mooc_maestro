class CreateUserCourses < ActiveRecord::Migration[5.1]
  def change
    create_table :user_courses do |t|
      t.integer :user_id
      t.integer :course_id
      t.datetime :start_date
      t.datetime :end_date
      t.float :progress_in_hours
      t.string :note
    end
  end
end
