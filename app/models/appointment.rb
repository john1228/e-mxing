class Appointment < ActiveRecord::Base
  after_create :build_track
  belongs_to :coach
  belongs_to :course


  def as_json
    {
        course: course_name,
        start: start_time,
        end: '',
        venues: venues,
        address: address,
        booked: (offline.blank? ? 0 : offline.split(',')) + (online.blank? ? 0 : online.split(',').length)
    }
  end

  private
  #预约完成后为用户创建运动轨迹
  def build_track
    Track.create(user_id: user_id, track_type: course.type, start: "#{date} #{start_time}", during: course_during*classes)
  end
end
