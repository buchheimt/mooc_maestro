class User < ActiveRecord::Base

  has_secure_password
  has_many :user_courses
  has_many :courses, through: :user_courses
  has_many :programs, through: :courses
  has_many :platforms, through: :programs
  has_many :subjects, through: :courses

  def program_progress(program)
    hours_complete = 0
    hours_total = 0
    program.courses.each do |course|
      hours_total += course.length_in_hours
      hours_complete += UserCourse.get_progress(self, course)
    end
    (hours_complete / hours_total * 100).round
  end

  def program_progress_formatted(program)
    hours_complete = 0
    hours_total = 0
    program.courses.each do |course|
      hours_total += course.length_in_hours
      hours_complete += UserCourse.get_progress(self, course)
    end
    "#{hours_complete} / #{hours_total}"
  end

end
