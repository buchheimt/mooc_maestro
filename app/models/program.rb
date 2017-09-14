class Program < ActiveRecord::Base

  include Slugifiable::InstanceMethods
  extend Slugifiable::ClassMethods

  has_many :courses
  has_many :users, through: :courses
  belongs_to :platform
  has_many :subjects, through: :courses

  def if_assigned
    self unless name == "Individual Courses"
  end

  def length
    courses = self.courses
    return nil if courses.any? {|c| c.length_in_hours.nil?} || courses.empty?
    courses.inject(0) {|sum, c| sum += c.length_in_hours}
  end

  def self.all_assigned
    self.all.select {|pr| pr.if_assigned}
  end

  def self.all_open
    self.all.reject {|pr| pr.if_assigned}
  end
end
