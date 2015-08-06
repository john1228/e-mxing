class Sku < ActiveRecord::Base
  scope :online, -> { where(status: 1) }

  def as_json
    {
        sku: sku,
        name: course_name,
        seller: seller,
        cover: course_cover,
        selling: selling_price,
        guarantee: course_guarantee,
        address: address,
        distance: attributes['distance']||0
    }
  end

  def detail
    json_hash = {
        sku: sku,
        name: course.name,
        images: course.is_a?(Course) ? course.images.map { |image|
          {
              thumb: image.photo.thumb.url,
              original: image.photo.url
          }
        } : course.image.map { |item| {thumb: item.thumb.url, original: item.url} },
        guarantee: course.guarantee,
        market: market_price,
        selling: selling_price,
        limit: limit.blank? ? '-1' : limit,
        store: limit.blank? ? '-1' : store,
        score: rand(5),
        type: course.type,
        style: course.style,
        during: course.during,
        exp: Date.today.next_day(course.exp).strftime('%Y-%m-%d'),
        proposal: course.proposal,
        seller: {
            mxid: seller_user.profile.mxid,
            name: seller_user.profile.name,
            avatar: seller_user.profile.avatar.thumb.url,
            mobile: seller_user.is_a?(Coach) ? seller_user.mobile : seller_user.profile.mobile
        },
        address: [{
                      name: address,
                      coordinate: {
                          lng: coordinate.x,
                          lat: coordinate.y
                      }
                  }],
        intro: course.intro,
        special: course.special,
        service: [1, 2, 3, 4].sample(rand(5)),
        buyers: {
            count: orders_count,
            items: buyers
        },
        comments: [
            count: tmp_comments_count,
            items: comments.take(5)
        ]
    }
    json_hash = json_hash.merge(limit_time: {start: course.limit_start.strftime('%Y-%m-%d %H:%M'), end: course.limit_end.strftime('%Y-%m-%d %H:%M')}) if course.has_attribute?(:limit_start)
    json_hash
  end

  def course
    if sku.start_with?('SC')
      ServiceCourse.find_by(id: course_id)
    else
      Course.find_by(id: course_id)
    end
  end

  def related_sellers
    Sku.where('sku LIKE ? and course_id=?', sku[0, 2] + '%', course_id).map { |sku|
      {
          seller: sku.seller,
          address: sku.address,
          tel: seller_user.is_a?(Service) ? seller_user.profile.mobile : seller_user.mobile,
          coordinate: {
              lng: sku.coordinate.x,
              lat: sku.coordinate.y
          }
      }
    }
  end

  def tmp_comments_count
    Comment.where('sku LIKE ?', sku[0, sku.rindex('-')] + '%').count
  end

  def comments
    Comment.where.not(image: []).where('sku LIKE ?', sku[0, sku.rindex('-')] + '%')
  end


  private
  def buyers
    User.where(id: Order.includes(:order_item).where('order_items.sku LIKE ?', sku[0, sku.rindex('-')] + '%').order(id: :desc).limit(5).pluck(:user_id)).map { |user|
      {
          mxid: user.profile.mxid,
          name: user.profile.name,
          avatar: user.profile.avatar.thumb.url
      }
    }
  end

  def seller_user
    if sku.start_with?('SC')
      user = Service.find_by(id: seller_id)
    else
      user = Coach.find_by(id: seller_id)
    end
    user
  end
end
