class Order < ActiveRecord::Base
  include MessageAble
  before_create :detect_params
  after_save :backend_task #当订单完成支付时，生成课表
  default_scope { where('1=1').order(id: :desc) }
  scope :unpay, -> { where(status: STATUS[:unpay]) }
  scope :pay, -> { where(status: STATUS[:pay]) }

  belongs_to :user
  belongs_to :coach
  has_many :order_items, dependent: :destroy
  has_many :lessons, dependent: :destroy
  attr_accessor :item
  STATUS = {delete: -1, cancel: 0, unpay: 1, pay: 2, complete: 4}
  PAY_TYPE = {alipay: 1, webchat: 2, jd: 3}
  private
  def detect_params
    self.no = "#{Time.now.to_i}#{user_id}#{%w'0 1 2 3 4 5 6 7 8 9'.sample(3).join('')}"
    #单产品购买
    item_info = item.split('|')
    course_id, course_count = item_info[0], item_info[1]
    course = Course.find_by(id: course_id)
    order_items.build(course_id: course.id, name: course.name, type: course.type, during: course.during,
                      cover: (course.course_photos.first.blank? ? '' : course.course_photos.first.photo),
                      price: course.price, amount: course_count)
    self.total, total_price = course.price*course_count.to_i, course.price*course_count.to_i
    #如果用户使用优惠券
    if coupons.present?
      user_coupons = user.wallet.coupons
      use_coupons = coupons.split(',').map { |coupon| coupon.to_i }
      #判断使用的优惠券是否是用户拥有的优惠券
      use_coupons.map { |coupon| return false unless user_coupons.include?(coupon) }
      Coupon.where(id: use_coupons).map { |coupon|
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
        return false if coupon.min >= total_price
        total_price -= coupon.discount
      }
      user.wallet.update(coupons: (user_coupons-use_coupons), action: WalletLog::ACTIONS['消费'])
    end
    #TODO:美型豆使用
    self.coach = course.coach
    self.pay_amount = total_price >0 ? total_price : 0
    if pay_amount>0
      self.status = STATUS[:unpay]
    else
      self.status = STATUS[:pay]
    end
  end

  def backend_task
    if status.eql?(STATUS[:pay])
      #现在只购买一个课程,逻辑遵循一个课时走
      item = order_items.first
      #设置课时
      lessons.create(coach: coach, user: user, course: item.course, available: item.amount, used: 0,
                     exp: Date.today.next_day(item.course.exp.to_i), contact_name: contact_name, contact_phone: contact_phone)

      #结算
      services = ServiceMember.select(:service_id).where(coach: coach).uniq
      if services.size==1
        service = services.take.service
        #挂在单加服务号时，钱转给服务号
        wallet = Wallet.find_or_create_by(user: service)
        wallet.update(balance: (wallet.balance + total), action: WalletLog::ACTIONS['卖课收入']) unless item.course.guarantee.eql?(Course::GUARANTEE)
      else
        #挂在多家结构时,钱直接转给私教
        wallet = Wallet.find_or_create_by(user: coach)
        wallet.update(balance: (wallet.balance + total), action: WalletLog::ACTIONS['卖课收入']) unless item.course.guarantee.eql?(Course::GUARANTEE)
      end
      #TODO 短信推送
    end

    user.wallet.update(coupons: ((user.wallet.coupons||[]) + coupons.split(',').map { |coupon| coupon.to_i }), bean: (user.wallet.bean + bean), action: WalletLog::ACTIONS['订单取消']) if status.eql?(STATUS[:cancel]) && coupons.present?
  end
end
