class AppointmentSetting < ActiveRecord::Base
  belongs_to :coach
  belongs_to :address
  class<<self
    def effect(date)
      one_to_one = (where(start_date: date, course_name: nil)||where('start_date< and repeat=? and course_name=?', date, true, nil)).first
      one_to_many = where.not(course_name: nil).where(start_date: date)
      {
          one: one_to_one.blank? ? {start: '9:00', end: '21:00'} : {start: one_to_one.start_time, end: one_to_one.end_time},
          many: one_to_many.collect { |many|
            {
                course: {
                    name: many.course_name,
                    type: many.course_type
                },
                start: many.start_time,
                end: many.end_time,
                place: many.place,
                address: many.school_address_of_setting
            }
          }
      }
    end
  end

  def school_address_of_setting
    coach.addresses.find_by(id: address).as_json
  end
end
