class CreateCourses < ActiveRecord::Migration[5.1]
  def change
    create_table :courses do |t|
      t.string :name
      t.string :description
      t.float :length_in_hours
      t.integer :program_id
    end
  end
end
