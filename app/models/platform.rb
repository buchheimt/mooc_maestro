class Platform < ActiveRecord::Base

  has_many :programs
  has_many :courses, through: :programs
  has_many :users, through: :courses
  has_many :subjects, through: :courses

  def slug
    return self.name.downcase.split.join("-")
  end

  def self.find_by_slug(slug)
    self.all.detect {|program| program.slug == slug}
  end

end
