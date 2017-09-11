class UserCourse < ActiveRecord::Base

  belongs_to :user
  belongs_to :course

  def self.find_on_join(user, course)
    self.all.find_by(user_id: user.id, course_id: course.id)
  end

  def hours_of_total
    "#{self.progress_in_hours} / #{self.course.length_in_hours}"
  end

  def self.establish(user, course)
    user.courses << course
    course.users << user
    user.save
    course.save
    user_course = self.find_on_join(user, course)
    user_course.start_date = Time.now
    user_course.progress_in_hours = 0
    user_course.save
  end

  def self.get_progress(user, course)
    user_course = self.find_on_join(user, course)
    user_course.progress_in_hours
  end

end
