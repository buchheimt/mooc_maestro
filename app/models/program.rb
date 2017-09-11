class Program < ActiveRecord::Base

  has_many :courses
  has_many :users, through: :courses
  belongs_to :platform
  has_many :subjects, through: :courses

  def slug
    return self.name.downcase.split.join("-")
  end

  def self.find_by_slug(slug)
    self.all.detect {|program| program.slug == slug}
  end

  def length
    return nil if self.courses.any? {|c| c.length_in_hours.nil?} || self.courses.empty?
    sum = 0
    self.courses.each {|c| sum += c.length_in_hours}
    sum
  end

end
