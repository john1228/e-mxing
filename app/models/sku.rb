class Sku < ActiveRecord::Base
  self.primary_key = :sku
  scope :online, -> { where(status: 1) }
  scope :coach_courses, -> { where('sku LIKE ?', 'CC%') }
  scope :service_courses, -> { where('sku LIKE ?', 'SC%') }
  scope :recommended, -> { joins(:recommend).order('recommends.id desc') }
  has_one :recommend, -> { where(type: Recommend::TYPE[:course]).order(id: :desc) }, foreign_key: :recommended_id
  belongs_to :course, class_name: ServiceCourse, foreign_key: :course_id
  belongs_to :service
  has_many :concerneds, foreign_key: :sku

  before_save :offline
  before_create :injection

  def as_json
    {
        sku: sku,
        name: course_name,
        seller: seller_user.profile.name,
        cover: course_cover,
        selling: selling_price.to_i,
        guarantee: course_guarantee,
        address: address,
        store: store||-1,
        distance: attributes['distance']||0,
        coordinate: {
            lng: coordinate.x,
            lat: coordinate.y
        }
    }
  end

  def detail
    service = Service.find_by(id: service_id)
    json_hash = {
        sku: sku,
        name: course.name,
        cover: course_cover,
        images: course.image.map { |item| {thumb: item.url, original: item.url} },
        guarantee: course.guarantee,
        market: market_price.to_i,
        selling: selling_price.to_i,
        store: store||-1,
        limit: limit||-1,
        score: score,
        type: course.type,
        style: course.style,
        during: course.during,
        exp: Date.today.next_day(course.exp).strftime('%Y-%m-%d'),
        proposal: course.proposal,
        seller: {
            mxid: seller_user.profile.mxid,
            name: seller_user.profile.name,
            avatar: seller_user.profile.avatar.url,
            mobile: seller_user.profile.identity.eql?(1) ? seller_user.mobile : service.profile.mobile,
            identity: seller_user.profile.identity,
            tags: seller_user.profile.tags
        },
        address: [{
                      name: address,
                      agency: service.profile.name,
                      coordinate: {
                          lng: coordinate.x,
                          lat: coordinate.y
                      }
                  }],
        intro: course.intro,
        special: course.special,
        service: service.profile.service,
        buyers: {
            count: orders_count,
            items: buyers
        },
        status: status,
        comments: [
            count: comments.count,
            items: image_comments.take(5)
        ]
    }
    json_hash = json_hash.merge(limit_time: {start: course.limit_start.strftime('%Y-%m-%d %H:%M'), end: course.limit_end.strftime('%Y-%m-%d %H:%M')}) if course.has_attribute?(:limit_start)&&course.limit_start.present?
    json_hash
  end


  def related_sellers
    Sku.where('sku LIKE ? and course_id=?', sku[0, 2] + '%', course_id).map { |sku|
      seller_user = sku.seller_user
      phone = /^((\d{11})|^((\d{7,8})|(\d{4}|\d{3})-(\d{7,8})|(\d{4}|\d{3})-(\d{7,8})-(\d{4}|\d{3}|\d{2}|\d{1})|(\d{7,8})-(\d{4}|\d{3}|\d{2}|\d{1}))$)$/
      if phone.match(seller_user.mobile).blank?
        tel = sku.service.profile.mobile if phone.match(sku.service.profile.mobile).present?
      else
        tel = seller_user.mobile
      end
      {
          seller: sku.service.profile.name,
          address: sku.address,
          tel: tel.to_s,
          coordinate: {
              lng: sku.coordinate.x,
              lat: sku.coordinate.y
          }
      }
    }
  end

  def score
    comments = Comment.where('sku LIKE ?', sku[0, sku.rindex('-')] + '%')
    if comments.present?
      comments.average(:score).to_f.round(2)
    else
      4
    end
  end

  def image_comments
    Comment.where('sku LIKE ? and array_length(image,1)>0', sku[0, sku.rindex('-')] + '%').order(id: :desc)
  end

  def comments
    Comment.where('sku LIKE ?', sku[0, sku.rindex('-')] + '%').order(id: :desc)
  end

  def limit_detect(user)
    Order.includes(:order_item).where(status: [Order::STATUS[:unpaid], Order::STATUS[:pay], Order::STATUS[:finish]]).where('orders.user_id=? AND order_items.sku LIKE ?', user, sku[0, sku.rindex('-')] + '%').sum('order_items.amount')
  end

  def buyers
    user_ids = Order.includes(:order_item).where('orders.status = ? and order_items.sku LIKE ?', Order::STATUS[:pay], sku[0, sku.rindex('-')] + '%').order(id: :desc).limit(5).pluck(:user_id)
    user_ids.map { |user_id|
      user = User.find_by(id: user_id)
      {
          mxid: user.profile.mxid,
          name: user.profile.name,
          avatar: user.profile.avatar.url
      }
    }
  end

  def seller_user
    User.find_by(id: seller_id)
  end

  protected
  def offline
    # self.status = 0 if store.eql?(0)
  end

  def injection
    self.orders_count = rand(100)
  end
end
