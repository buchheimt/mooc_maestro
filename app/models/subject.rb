class Subject < ActiveRecord::Base

  include Slugifiable::InstanceMethods
  extend Slugifiable::ClassMethods

  has_many :course_subjects
  has_many :courses, through: :course_subjects
  has_many :programs, through: :courses
  has_many :platforms, through: :programs
  has_many :users, through: :courses

end
