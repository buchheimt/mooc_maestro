class UserCourse < ActiveRecord::Base

  belongs_to :user
  belongs_to :course

  def self.find_by_user_and_course(user, course)
    self.all.find_by(user_id: user.id, course_id: course.id)
  end

end
