class Course < ActiveRecord::Base

  has_many :user_courses
  has_many :users, through: :user_courses
  belongs_to :program
  delegate :platform, to: :program
  has_many :course_subjects
  has_many :subjects, through: :course_subjects

  def slug
    name.downcase.split.join("-")
  end

  def get_length
    length_in_hours unless length_in_hours.nil? || length_in_hours <= 0
  end

  def self.find_by_slug(slug)
    self.all.detect {|c| c.slug == slug}
  end
end
