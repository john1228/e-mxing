class Lesson < ActiveRecord::Base
  belongs_to :user
  belongs_to :coach
  belongs_to :course
  belongs_to :order
  has_many :appointments
  before_create :build_code

  def as_json
    sku_course = Sku.find_by(sku: sku)
    {
        id: id,
        course: sku_course.course.name,
        student: user.profile.name,
        seller: sku_course.seller,
        available: available,
        used: used
    }
  end

  def detail
    sku_course = Sku.find_by(sku: sku)
    {
        id: id,
        course: sku_course.course.name,
        seller: sku_course.seller,
        available: available,
        used: used,
        during: sku_course.course.during,
        exp: exp,
        address: sku_course.related_sellers,
        qr_code: code
    }
  end

  private
  def build_code
    self.code = (1..available).map { |index|
      'L'+'%05d' % user_id + +'%04d' % order.id + '%02d' + index
    }
  end
end
