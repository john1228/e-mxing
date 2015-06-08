class Order < ActiveRecord::Base
  before_create :setting_default_values
  attr_accessor :item #只能购买单产品
  belongs_to :user
  has_many :order_items, dependent: :destroy
  STATUS = {unpay: 1, pay: 2}
  attr_accessor :item

  def as_json
    {
        no: no,
        contact_name: contact_name,
        contact_phone: contact_phone,
        items: order_items.collect { |item|
          item.as_json
        },
        coupons: '',
        bea: '',
        pay: pay_amount,
        created: created_at.to_i
    }
  end


  private
  def setting_default_values
    self.no = "#{Time.now.to_i}#{user_id}#{%w'0 1 2 3 4 5 6 7 8 9'.sample(3).join('')}"
    #单产品购买
    item_info = item.split(':')
    course_id, course_count = item_info[0], item_info[1]
    course = Course.find_by(id: course_id)
    order_items.build(course_id: course.id, name: course.name,
                      cover: (course.course_photos.first.blank? ? '' : course.course_photos.first.photo),
                      price: course.price, amount: course_count)
    total_price = course.price*course_count.to_i
    #如果用户使用优惠券
    if coupons.present?
      #检验优惠券的是否有效
      user_coupons = user.user_coupons.pluck(:coupon_id)
      coupons.split(',').map { |coupon| return false unless user_coupons.include?(coupon.to_i) }
      Coupon.where(id: coupons.split(',')).map { |coupon|
        #优惠券不在有效期内
        return false if (coupon.start_date> Date.today) || (coupon.end_date< Date.today)
        #种类是否满足要求
        case coupon.limit_category
          when Coupon::TYPE[:general]
          when Coupon::TYPE[:gyms]
            return false unless coupon.limit_ext.eql?(course.coach.id)
          when Coupon::TYPE[:course]
            return false unless coupon.limit_ext.eql?(course.id)
          when Coupon::TYPE[:service]
            member = ServiceMember.find_by(coach: course.coach)
            return false unless coupon.limit_ext.eql?(member.service.id)
          else
            return false
        end
        #判断金额是否满足
        return false if coupon.min > total_price
        total_price -= coupon.discount
      }
    end
    #TODO:美型豆使用
    self.pay_amount = total_price
    self.status = STATUS[:unpay]
  end
end