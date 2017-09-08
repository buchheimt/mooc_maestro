class Program < ActiveRecord::Base

  has_many :courses
  has_many :user_courses, through: :courses
  has_many :users, through: :user_courses
  belongs_to :platform

end
