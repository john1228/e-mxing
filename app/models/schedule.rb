class Schedule < ActiveRecord::Base
  belongs_to :coach

  def new_course_schedule(course, date, start)
    course = Sku.find(course)
    during = course.course.during


  end
end
