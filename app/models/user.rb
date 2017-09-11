class User < ActiveRecord::Base

  has_secure_password
  has_many :user_courses
  has_many :courses, through: :user_courses
  has_many :programs, through: :courses
  has_many :platforms, through: :programs
  has_many :subjects, through: :courses

  def get_program_progress(program)
    hours_complete = 0
    program.courses.each do |course|
      user_course = UserCourse.find_on_join(self, course)
      hours_complete += UserCourse.get_progress(self, course) if user_course
    end
    hours_complete
  end

  def program_progress_percentage(program)
    (get_program_progress(program) / program.length * 100).round
  end

  def program_progress_formatted(program)
    "#{get_program_progress(program).round} / #{program.length.round}"
  end

end
