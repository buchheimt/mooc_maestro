class Subject < ActiveRecord::Base

  has_many :course_subjects
  has_many :courses, through: :course_subjects
  has_many :programs, through: :courses
  has_many :platforms, through: :programs
  has_many :users, through: :courses

  def slug
    name.downcase.split.join("-")
  end

  def self.find_by_slug(slug)
    self.all.detect {|s| s.slug == slug}
  end
end
