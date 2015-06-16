class Appointment < ActiveRecord::Base
  belongs_to :coach
  belongs_to :course
  belongs_to :lesson
  after_create :build_track
  #0-取消的预约 1-等待上课|正在上课|等待确认 2-用户完成确认，等待评价 3-完成评价
  STATUS = {cancel: 0, waiting: 1, done: 2, complete: 3}
  after_update :payment

  def as_json
    {
        course: course.name,
        start: start_time,
        classes: classes,
        during: course.during,
        venues: venues,
        address: address,
        booked: (offline.blank? ? 0 : offline.split(',')) + (online.blank? ? 0 : online.split(',').length)
    }
  end

  private
  #预约完成后为用户创建运动轨迹
  def build_track
    Track.create(user_id: user_id, track_type: course.type, start: "#{date} #{start_time}", during: course_during.to_i*classes.to_i) if online.present?
  end

  def payment
    lesson.update(used: (lesson.used + 1)) if status.eql?(STATUS[:done])
  end
end
