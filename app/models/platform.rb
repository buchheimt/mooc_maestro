class Platform < ActiveRecord::Base

  has_many :programs
  has_many :courses, through: :programs
  has_many :users, through: :courses
  has_many :subjects, through: :courses

end
