class Lesson < ActiveRecord::Base
  belongs_to :user
  belongs_to :coach
  belongs_to :course
  belongs_to :order
  has_many :appointments

  def as_json
    {
        id: id,
        course: course.name,
        seller: coach.profile.name,
        available: available,
        used: used
    }
  end

  def detail
    {
        id: id,
        course: course.name,
        seller: coach.profile.name,
        available: available,
        used: used,
        during: during,
        exp: exp,
        code: code
    }
  end

  def code
    (1..available).map { |index|
      'L'+'%05d' % user_id + +'%04d' % id + '%02d' + index
    }
  end
end
