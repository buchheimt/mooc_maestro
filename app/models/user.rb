class User < ActiveRecord::Base

  has_secure_password
  has_many :user_courses
  has_many :courses, through: :user_courses

end
