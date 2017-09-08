class CreateCourseSubjects < ActiveRecord::Migration[5.1]
  def change
    create_table :course_subjects do |t|
      t.integer :course_id
      t.integer :subject_id
    end
  end
end
