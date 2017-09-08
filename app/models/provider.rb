class Platform < ActiveRecord::Base

  has_many :programs
  has_many :courses, through: :programs
  has_many :user_courses, through: :courses
  has_many :users, through: :user_courses

end
