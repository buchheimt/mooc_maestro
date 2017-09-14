class Platform < ActiveRecord::Base

  include Slugifiable::InstanceMethods
  extend Slugifiable::ClassMethods

  has_many :programs
  has_many :courses, through: :programs
  has_many :users, through: :courses
  has_many :subjects, through: :courses

  def if_assigned
    self unless name == "Unassigned"
  end

  def self.all_assigned
    self.all.select {|pl| pl.if_assigned}
  end

  def self.all_open
    self.all.reject {|pl| pl.if_assigned}
  end
end
