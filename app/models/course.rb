class Course < ActiveRecord::Base

  has_many :user_courses
  has_many :users, through: :user_courses
  belongs_to :program
  delegate :platform, to: :program
  has_many :course_subjects
  has_many :subjects, through: :course_subjects

  def slug
    return self.name.downcase.split.join("-")
  end

  def self.find_by_slug(slug)
    self.all.detect {|course| course.slug == slug}
  end

end
