class Course < ActiveRecord::Base

  include Slugifiable::InstanceMethods
  extend Slugifiable::ClassMethods

  has_many :user_courses
  has_many :users, through: :user_courses
  belongs_to :program
  delegate :platform, to: :program
  has_many :course_subjects
  has_many :subjects, through: :course_subjects

  def get_length
    length_in_hours unless length_in_hours.nil? || length_in_hours <= 0
  end
end
