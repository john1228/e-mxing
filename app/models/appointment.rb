class Appointment < ActiveRecord::Base
  belongs_to :coach
  belongs_to :user
  belongs_to :course
  belongs_to :lesson
  STATUS = {cancel: -1, waiting: 0, complete: 1, done: 2}
  after_update :confirm
  after_create :notice

  def as_json
    {
        id: id,
        course: {
            id: course.id,
            name: course.name,
            cover: (course.course_photos.first.thumb.url rescue ''),
            type: course.type,
            style: course.style,
            during: course.during
        },
        user: user.profile.summary_json,
        status: status
    }
  end

  private
  def confirm
    lesson.update(used: (lesson.used + 1)) if status.eql?(STATUS[:complete])
  end
  def notice
    #通知学员
  end
end
