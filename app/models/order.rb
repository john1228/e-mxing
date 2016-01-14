class Order < ActiveRecord::Base
  before_create :prepare
  after_save :backend #当订单完成支付时，生成课表
  default_scope { order(updated_at: :desc) }
  scope :unpaid, -> { where(status: STATUS[:unpaid]) }
  scope :pay, -> { where(status: STATUS[:pay]) }
  belongs_to :user
  belongs_to :service
  belongs_to :coach
  has_one :order_item, dependent: :destroy
  has_one :lesson, dependent: :destroy
  belongs_to :seller, class: User
  attr_accessor :custom_pay_amount

  STATUS = {delete: -1, cancel: 0, unpaid: 1, pay: 2, complete: 4}
  PAY_TYPE = {alipay: 1, webchat: 2, jd: 3}

  alias_attribute :coupon, :coupons
  accepts_nested_attributes_for :order_item
  enum order_type: [:platform, :face_to_face]

  validate :validate_coupon, if: Proc.new { |order| order.coupon.present? }, on: :create
  validate :validate_amount, on: :create
  validate :validate_user, on: :update

  mount_uploader :contact_avatar, ProfileUploader


  protected
  #检验验证码
  def validate_coupon
    using_coupon = Coupon.find(coupon)
    if using_coupon.blank?
      errors.add(:coupon, '无效的优惠券')
    else
      if user.wallet.coupons.include?(using_coupon.id)
        course = Sku.find_by(sku: order_item.sku)
        errors.add(:coupon, '您使用的优惠券还未到使用时间') if using_coupon.start_date > Date.today
        errors.add(:coupon, '您使用的优惠券已经过期') if using_coupon.end_date < Date.today
        errors.add(:coupon, '无效的优惠券') unless using_coupon.limit_category.eql?(Coupon::TYPE[:general])
        errors.add(:coupon, '你订单的金额不满足使用该优惠券的条件') if (course.selling_price * order_item.amount) < using_coupon.min
      else
        errors.add(:coupon, '您还未拥有该优惠券')
      end
    end
  end

  #检验购买数量
  def validate_amount
    if user.present?
      course = Sku.find(order_item.sku)
      limit = course.limit.blank? ? -1 : course.limit
      store = course.store.blank? ? -1 : course.store
      if limit > 0
        purchased = Order.includes(:order_item)
                        .where(status: [Order::STATUS[:unpaid], Order::STATUS[:pay], Order::STATUS[:finish]])
                        .where('orders.user_id=? AND order_items.sku = ?', user, course.sku)
                        .sum('order_items.amount')
        if (purchased + order_item.amount) > limit
          errors.add(:limit, '购买数量超出限制')
        end
      end
      if store >= 0
        if order_item.amount > store
          errors.add(:store, '库存不足')
        end
      end
    end
  end

  private
  def prepare
    course = Sku.find_by(sku: order_item.sku)
    self.no = "#{Time.now.to_i}#{user_id}#{%w'0 1 2 3 4 5 6 7 8 9'.sample(3).join('')}"
    if custom_pay_amount.present?
      self.total = custom_pay_amount
    else
      self.total = course.selling_price * order_item.amount.to_i
    end
    self.service_id = course.service_id
    self.seller_id = course.seller_id if seller_id.blank?
    self.coach_id = course.seller_id unless course.seller_id.eql?(course.service_id) #如果卖家是私教

    if coupon.present?
      using_coupon = Coupon.find(coupon)
      self.pay_amount = using_coupon.discount > total ? 0 : (total-using_coupon.discount)
    else
      self.pay_amount = total
    end

    if pay_amount > 0
      self.status = STATUS[:unpaid]
    else
      self.status = STATUS[:pay]
    end
    #产品购买
    transaction do
      store = course.store.blank? ? -1 : course.store
      #更新库存
      if store > 0
        #TODO: 连店销售 共享库存
        course.update(store: (course.store - order_item.amount))
      end
      #更新
      if coupon.present?
        user_wallet = Wallet.find_by(user_id: user_id)
        user_wallet.update(action: WalletLog::ACTIONS['消费'], coupons: user_wallet.coupons - [coupon.to_i])
      end
    end if user.present?
  end

  def validate_user
    if status.eql?(STATUS[:pay])
      if user.blank?
        user = User.find_by(mobile: contact_phone)
        if user.present?
          self.user_id = user.id
        else
          user = User.new(mobile: contact_phone, password: '12345678', profile_attributes: {name: contact_name, avatar: contact_avatar})
          if user.save
            self.user_id = user.id
          else
            errors.add(:user, '创建用户失败')
          end
        end
      end
    end
  end

  def backend
    unless status_was.eql?(status)
      case status
        when STATUS[:delete]
        when STATUS[:cancel]
        when STATUS[:unpaid]
          OrderJob.set(wait: 2.hours).perform_later(id)
        when STATUS[:pay]
          #现在只购买一个课程,逻辑遵循一个课时走
          sku = Sku.find(order_item.sku)
          transaction do
            #钱的處理
            wallet = Wallet.find_or_create_by(user_id: sku.service_id)
            wallet.update(action: WalletLog::ACTIONS['卖课收入'], balance: wallet.balance + total)
            Sku.where(course_id: sku.course_id).update_all("orders_count =  orders_count + #{order_item.amount}")
            member = Member.find_by(user_id: user_id, service_id: sku.service_id)
            if member.present?
              #创建会员卡
              if sku.course?
                membership_card = MembershipCard.create(
                    client_id: service.client_id,
                    service_id: service_id,
                    order_id: id,
                    member_id: member.id,
                    card_type: sku.product.card_type.card_type,
                    name: sku.product.name,
                    value: sku.product.card_type.value,
                    supply_value: order_item.amount + giveaway.to_i,
                    open: Date.today,
                    valid_days: sku.product.card_type.valid_days,
                    delay_days: sku.product.card_type.delay_days
                )
              else
                membership_card = MembershipCard.create(
                    client_id: service.client_id,
                    service_id: service_id,
                    order_id: id,
                    member_id: member.id,
                    card_type: sku.product.card_type.card_type,
                    name: sku.product.name,
                    value: sku.product.card_type.value*order_item.amount + giveaway.to_i,
                    open: Date.today,
                    valid_days: sku.product.card_type.valid_days,
                    delay_days: sku.product.card_type.delay_days
                )
              end

              #创建会员卡日志
              membership_card.logs.create(
                  action: 'buy',
                  service_id: service.id,
                  change_amount: sku.product.card_type.value*order_item.amount + giveaway.to_i,
                  pay_amount: total,
                  pay_type: 'mx',
                  seller: coach.present? ? coach.profile.name : service.profile.name,
                  operator: '美型',
                  remark: '美型APP购买'
              )
            else
              #创建会员
              member = Member.mx.full.create(
                  client_id: service.client_id,
                  service_id: service.id,
                  user_id: user_id,
                  name: contact_name,
                  mobile: contact_phone,
                  avatar: contact_avatar.blank? ? user.profile.avatar : contact_avatar,
                  gender: user.profile.gender
              )
              #创建会员卡
              if sku.course?
                membership_card = MembershipCard.create(
                    client_id: service.client_id,
                    service_id: service_id,
                    order_id: id,
                    member_id: member.id,
                    card_type: sku.product.card_type.card_type,
                    name: sku.product.name,
                    value: sku.product.card_type.value,
                    supply_value: order_item.amount + giveaway.to_i,
                    open: Date.today,
                    valid_days: sku.product.card_type.valid_days,
                    delay_days: sku.product.card_type.delay_days
                )
              else
                membership_card = MembershipCard.create(
                    client_id: service.client_id,
                    service_id: service_id,
                    order_id: id,
                    member_id: member.id,
                    card_type: sku.product.card_type.card_type,
                    name: sku.product.name,
                    value: sku.product.card_type.value*order_item.amount + giveaway.to_i,
                    open: Date.today,
                    valid_days: sku.product.card_type.valid_days,
                    delay_days: sku.product.card_type.delay_days
                )
              end
              #创建会员卡日志
              membership_card.logs.create(
                  action: 'buy',
                  service_id: service.id,
                  change_amount: sku.product.card_type.value*order_item.amount + giveaway.to_i,
                  pay_amount: total,
                  pay_type: 'mx',
                  seller: coach.present? ? coach.profile.name : service.profile.name,
                  operator: '美型',
                  remark: '美型APP购买'
              )
            end
          end
        when STATUS[:cancel]
          transaction do
            sku = Sku.find(order_item.sku)
            if sku.store.present? && sku.store > 0
              Sku.where(course_id: sku.course_id).update_all("store = store + #{order_item.amount})")
            end
            if coupons.present? || bean.present?
              wallet = Wallet.find_by(user_id: :user_id)
              wallet.update(
                  coupons: wallet.coupons||[] + coupons.split(','),
                  bean: wallet.bean + bean,
                  action: WalletLog::ACTIONS['订单取消']
              )
            end
          end
        else
          errors.add(:status, '错误的订单状态')
      end
    end
  end

end
