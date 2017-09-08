class Course < ActiveRecord::Base

  has_many :user_courses
  has_many :users, through: :user_courses
  belongs_to :program
  delegate :platforms, to: :program
  has_many :course_subjects
  has_many :subjects, through: :course_subjects

end
