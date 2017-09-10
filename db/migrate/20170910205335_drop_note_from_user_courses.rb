class DropNoteFromUserCourses < ActiveRecord::Migration[5.1]
  def change
    remove_column :user_courses, :note
  end
end
