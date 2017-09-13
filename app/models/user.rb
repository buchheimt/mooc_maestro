class User < ActiveRecord::Base

  has_secure_password
  has_many :user_courses
  has_many :courses, through: :user_courses
  has_many :programs, through: :courses
  has_many :platforms, through: :programs
  has_many :subjects, through: :courses

  def make_creator(topic)
    topic.creator_id = id
    topic.save
  end

  def get_program_progress(program)
    program.courses.inject(0) {|sum, c| sum += UserCourse.get_progress(self, c)}
  end

  def program_progress_percentage(program)
    length = program.length
    "#{(get_program_progress(program) / length * 100).round}%" if length
  end

  def program_progress_formatted(program)
    length = program.length
    "#{get_program_progress(program).round} / #{length.round}" if length
  end
end
