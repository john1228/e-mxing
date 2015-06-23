class AppointmentSetting < ActiveRecord::Base
  belongs_to :coach
  belongs_to :address
  validates_uniqueness_of :start_date, scope: :time
  class<<self
    def effect(date)
      one_to_one = (where(start_date: date, course_name: nil).order(id: :desc)||where('start_date< and repeat=? and course_name=?', date, true, nil)).first


      one_to_many = where.not(course_name: nil).where(start_date: date)
      {
          one: one_to_one.blank? ? {address: {}, time: [{start: '9:00', end: '21:00'}]} : {
              address: one_to_one.school_address, time: one_to_one.time.split(',').collect { |item|
                time_ary = item.split('|')
                {
                    start: time_ary[0],
                    end: time_ary[1]
                }
              }},
          many: one_to_many.collect { |many|
            time = many.time.split('|')
            {
                course: {
                    name: many.course_name,
                    type: many.course_type
                },
                start: time[0],
                end: time[1],
                place: many.place,
                address: many.school_address
            }
          }
      }
    end

    def set_of_many(date, time)
      where.not(course_name: nil).where('start_date=? and time ~* ?', date, "^#{time}").take
    end
  end

  def school_address
    coach.addresses.find_by(id: address).as_json
  end
end
