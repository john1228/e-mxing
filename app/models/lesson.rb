class Lesson < ActiveRecord::Base
  belongs_to :user
  belongs_to :coach
  belongs_to :course
  belongs_to :order
  has_many :appointments
  before_create :build_code

  def as_json
    sku_info = Sku.find_by(sku: sku)
    {
        id: id,
        course: sku_info.course.name,
        student: user.profile.name,
        seller: sku_info.seller,
        available: available,
        used: used
    }
  end

  def detail
    sku_info = Sku.find_by(sku: sku)
    {
        id: id,
        course: sku_info.course.name,
        seller: sku_info.seller,
        seller_type: sku_info.start_with?('CC') ? 'coach' : 'service',
        available: available,
        used: used,
        during: sku_info.course.during,
        exp: exp,
        address: sku_info.related_sellers,
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
