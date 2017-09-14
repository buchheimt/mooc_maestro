class User < ActiveRecord::Base

  has_secure_password
  has_many :user_courses
  has_many :courses, through: :user_courses
  has_many :programs, through: :courses
  has_many :platforms, through: :programs
  has_many :subjects, through: :courses

  def make_creator(topic)
    topic.creator_id = id
    topic.save
  end
end
