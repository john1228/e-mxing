class Order < ActiveRecord::Base
  before_create :detect_params
  after_save :backend_task #当订单完成支付时，生成课表
  default_scope { where('1=1').order(updated_at: :desc) }
  scope :unpay, -> { where(status: STATUS[:unpay]) }
  scope :pay, -> { where(status: STATUS[:pay]) }

  belongs_to :user
  belongs_to :coach
  has_one :order_item, dependent: :destroy
  has_many :lessons, dependent: :destroy
  attr_accessor :item, :sku, :amount
  STATUS = {delete: -1, cancel: 0, unpay: 1, pay: 2, complete: 4}
  PAY_TYPE = {alipay: 1, webchat: 2, jd: 3}
  private
  def detect_params
    self.no = "#{Time.now.to_i}#{user_id}#{%w'0 1 2 3 4 5 6 7 8 9'.sample(3).join('')}"
    #产品购买
    sku_info = Sku.find_by(sku: sku)

    #库存不足
    if sku_info.store >= 0 && sku_info.store<amount
      errors.add(:store, '库存不足')
      return false
    end
    #限制数量
    if sku_info.limit >= 0&& sku_info.limit<amount
      errors.add(:limit, '您够卖到数量超出限制')
      return false
    end

    course = sku_info.course
    build_order_item(sku: sku, name: course.name, type: course.type, during: course.during,
                     cover: course.cover, price: sku_info.selling_price, amount: amount)
    self.total, total_price = sku_info.selling_price*order_item.amount, sku_info.selling_price*order_item.amount
    #如果用户使用优惠券
    if coupons.present?
      user_coupons = user.wallet.coupons
      use_coupons = coupons.split(',').map { |coupon| coupon.to_i }
      #判断使用的优惠券是否是用户拥有的优惠券
      use_coupons.map { |coupon|
        unless user_coupons.include?(coupon)
          errors.add(:coupon, '无效的优惠券')
          return false
        end
      }
      Coupon.where(id: use_coupons).map { |coupon|
        #优惠券不在有效期内
        if (coupon.start_date> Date.today)
          errors.add(:coupon, '优惠券还未启用')
          return false
        elsif (coupon.end_date< Date.today)
          errors.add(:coupon, '优惠券已经过期')
          return false
        end
        #种类是否满足要求
        case coupon.limit_category
          when Coupon::TYPE[:general]
          when Coupon::TYPE[:gyms]
            unless coupon.limit_ext.eql?(course.coach.id)
              errors.add(:coupon, '无效的私教优惠券')
              return false
            end
          when Coupon::TYPE[:course]
            unless coupon.limit_ext.eql?(course.id)
              errors.add(:coupon, '无效的课程优惠券')
              return false
            end
          when Coupon::TYPE[:service]
            errors.add(:coupon, '无效的优惠券')
            return false
          else
            errors.add(:coupon, '无效的优惠券')
            return false
        end
        #判断金额是否满足
        if coupon.min >= total_price
          errors.add(:coupon, '订单金额未满足要求')
          return false
        end
        total_price -= coupon.discount
      }
      user.wallet.update(coupons: (user_coupons-use_coupons), action: WalletLog::ACTIONS['消费'])
    end
    #TODO:美型豆使用
    self.coach = course.coach if course.is_a?(Course)
    self.pay_amount = total_price >0 ? total_price : 0
    if pay_amount>0
      self.status = STATUS[:unpay]
    else
      self.status = STATUS[:pay]
    end
  end

  def backend_task
    case status
      when STATUS[:unpay]
        sku_info = Sku.find_by(sku: order_item.sku)
        Sku.where('sku LIKE ?', sku[0, sku.rindex('-')] + '%').update_all(store: (sku_info.store - order_item.amount)) if sku_info.store > -1
        OrderJob.set(wait: 2.hours).perform_later(id)
      when STATUS[:pay]
        #现在只购买一个课程,逻辑遵循一个课时走
        sku_info = Sku.find_by(sku: order_item.sku)
        course = sku_info.course
        if course.is_a?(Course)
          Lesson.create(order_id: id, sku: order_item.sku, coach_id: sku_info.seller_id, user: user, available: order_item.amount, used: 0,
                        exp: Date.today.next_day(course.exp), contact_name: contact_name, contact_phone: contact_phone) if lessons.blank?
          #钱的處理
          service = course.coach.service
          wallet = service.nil? ? Wallet.find_or_create_by(user: course.coach) : Wallet.find_or_create_by(user: service)
          wallet.update(balance: (wallet.balance + total), action: WalletLog::ACTIONS['卖课收入']) unless course.guarantee.eql?(Course::GUARANTEE)
          MessageJob.perform_later(sku_info.seller_id, MESSAGE['order'] % [user.profile.name, sku_info.course_name, no])
        else
          Lesson.create(order_id: id, sku: order_item.sku, user: user, available: order_item.amount, used: 0,
                        exp: Date.today.next_day(course.exp), contact_name: contact_name, contact_phone: contact_phone) if lessons.blank?
          #钱的處理
          wallet = Wallet.find_or_create_by(user_id: sku_info.seller_id)
          wallet.update(balance: (wallet.balance + total), action: WalletLog::ACTIONS['卖课收入']) unless course.guarantee.eql?(Course::GUARANTEE)
        end

      #结算
      when STATUS[:cancel]
        sku_info = Sku.find_by(sku: order_item.sku)
        Sku.where('sku LIKE ?', sku[0, sku.rindex('-')] + '%').update_all(store: (sku_info.store + order_item.amount)) if sku_info.store > -1
        user.wallet.update(coupons: ((user.wallet.coupons||[]) + (coupons||'').split(',').map { |coupon| coupon.to_i }), bean: (user.wallet.bean + bean.to_i), action: WalletLog::ACTIONS['订单取消']) if coupons.present?||bean.present?
    end
  end
end
