class AppointmentSetting < ActiveRecord::Base
  belongs_to :coach
  belongs_to :address
  validates_uniqueness_of :start_date, scope: :time
  before_save :validate_time
  class<<self
    def effect(date)
      one_to_one = (where(start_date: date, course_name: nil).order(id: :desc)||where('start_date< and repeat=? and course_name=?', date, true, nil)).order(start_date: :desc).first
      one_to_many = where.not(course_name: nil).where(start_date: date)
      {
          one: one_to_one.blank? ? {address: {}, time: [{start: '9:00', end: '21:00'}]} : {
              address: one_to_one.school_address,
              time: one_to_one.time.split(',').collect { |item|
                time_ary = item.split('|')
                {
                    start: time_ary[0],
                    end: time_ary[1]
                }
              }},
          many: one_to_many.collect { |many|
            course = Course.find_by(name: course_name)
            if course.present?
              time = many.time.split('|')
              {
                  course: {
                      id: course.id,
                      name: many.course_name,
                      type: many.course_type
                  },
                  start: time[0],
                  end: time[1],
                  place: many.place,
                  address: many.school_address
              }
            end
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

  private
  def validate_time
    #校验数据正确性
    time.split(',').map { |item|
      time_ary = item.split('|')
      start_time, end_time = Time.parse(time_ary[0], Date.today), Time.parse(time_ary[1], Date.today)
      return false if (end_time-start_time) < 1800
    }
    #如果是团操课
    unless course_name.blank?
      settings = where.not(course_name: nil).where(start_date: start_date)
      setting_time_ary = time.split('|')
      setting_start, setting_end = Time.parse(setting_time_ary[0], Date.today), Time.parse(setting_time_ary[1], Date.today)
      settings.map { |setting|
        time_ary = setting.time.split('|')
        start_time, end_time = Time.parse(time_ary[0], Date.today), Time.parse(time_ary[1], Date.today)
        return false if (start_time< setting_start && setting_start < end_time) ||(start_time< setting_end && setting_end < end_time)
      }
    end
  end
end
