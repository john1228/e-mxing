class Coupon < ActiveRecord::Base
  #优惠范围(通用,限制私教,限制产品,限制服务号)
  TYPE = {general: 1, gyms: 2, course: 3, service: 4}
  validates_presence_of :name, :limit_category, :start_date, :end_date, :discount, :min
  validates_presence_of :limit_ext, if: Proc.new { |coupon|
                                    coupon.limit_category.eql?(TYPE[:gyms])||coupon.limit_category.eql?(TYPE[:course])||coupon.limit_category.eql?(TYPE[:service])
                                  }
  attr_accessor :amount
  before_create :build_code

  def as_json
    {
        no: id,
        name: name,
        discount: discount,
        info: info,
        start_date: start_date,
        end_date: end_date,
        limit_category: limit_category,
        limit_ext: limit_ext,
        min: min
    }
  end

  private
  def build_code
    self.code = (1..amount).map { |index|
      rand(10) + ('%02d' % index)
    }
  end
end
