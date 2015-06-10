class Appointment < ActiveRecord::Base
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
end
