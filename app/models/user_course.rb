class UserCourse < ActiveRecord::Base

  belongs_to :user
  belongs_to :course

  def add_progress(new_hours)
    self.progress_in_hours += new_hours
    if self.progress_in_hours >= course.length_in_hours
      self.progress_in_hours = course.length_in_hours
      self.end_date = Time.now
    elsif self.progress_in_hours < 0
      self.progress_in_hours = 0
    end
    save
  end

  def get_progress_formatted
    "#{progress_in_hours.round} / #{course.length_in_hours.round}"
  end

  def get_progress_percent
    (progress_in_hours / course.length_in_hours * 100).round
  end

  def self.find_on_join(user, course)
    self.all.find_by(user_id: user.id, course_id: course.id)
  end

  def self.establish(user, course)
    user.courses << course
    user_course = self.find_on_join(user, course)
    user_course.start_date = Time.now
    user_course.progress_in_hours = 0
    user_course.save
  end

  def self.get_progress(user, course)
    user_course = self.find_on_join(user, course)
    user_course.nil? ? 0 : user_course.progress_in_hours
  end

  def self.get_program_progress(user, program)
    program.courses.inject(0) {|sum, c| sum += self.get_progress(user, c)}
  end

  def self.program_progress_percentage(user, program)
    length = program.length
    "#{(get_program_progress(user, program) / length * 100).round}%" if length
  end

  def self.program_progress_formatted(user, program)
    length = program.length
    "#{get_program_progress(user, program).round} / #{length.round}" if length
  end
end
