class Lesson < ActiveRecord::Base
  before_create :build_code
  #self.primary_key = 'sku'
  belongs_to :user
  belongs_to :coach
  belongs_to :order
  has_many :appointments
  belongs_to :course, class: Sku, foreign_key: :sku

  class << self
    def classification_of_student(coach)
      coach_lessons = where(coach: coach).where('available > used')
      classification = coach_lessons.group_by { |lesson| lesson.user_id }
      classification.map { |user_id, lessons|
        profile = Profile.find_by(user_id: user_id)
        {
            student: {
                mxid: profile.mxid,
                name: profile.name,
                avatar: profile.avatar.url
            },
            course: {
                count: lessons.size,
                item: lessons.map { |lesson|
                  {
                      id: lesson.course.id,
                      name: lesson.course.course_name,
                      cover: lesson.course.course_cover,
                      during: lesson.course.course_during,
                      available: lesson.available,
                      used: lesson.used
                  }
                }
            }
        }
      }
    end
  end


  def as_json
    {
        id: id,
        course: course.course_name,
        student: user.profile.name,
        seller: course.seller,
        available: available,
        used: appointments.pluck(:code)
    }
  end

  def detail
    sku_info = Sku.find_by(sku: sku)

    json_hash = {
        id: id,
        course: sku_info.course.name,
        seller: sku_info.seller,
        seller_type: sku_info.seller_user.profile.identity,
        available: available,
        used: appointments.pluck(:code),
        during: sku_info.course_during,
        exp: exp,
        class_time: '',
        address: sku_info.related_sellers,
        qr_code: code
    }
    if sku_info.course.has_attribute?(:limit_start)&&sku_info.course.limit_start.present?
      json_hash = json_hash.merge(
          class_time:
              {
                  start: sku_info.course.limit_start.strftime('%Y-%m-%d %H:%M'),
                  end: sku_info.course.limit_end.strftime('%Y-%m-%d %H:%M')
              }
      )
    else
      json_hash = json_hash.merge(class_time: {start: '', end: ''})
    end
    json_hash
  end

  private
  def build_code
    self.code = (1..available).map { |index|
      'L' + Time.now.to_i.to_s + index.to_s + %w'0 1 2 3 4 5 6 7 8 9'.sample(2).join
    }
  end
end
