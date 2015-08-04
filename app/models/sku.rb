class Sku < ActiveRecord::Base

  def as_json
    {
        sku: sku,
        name: course.name,
        seller: seller,
        cover: course.cover,
        selling: selling_price,
        address: address
    }
  end

  def detail
    json_hash = {
        sku: sku,
        name: course.name,
        images: course.images.map { |image|
          {
              thumb: image.photo.thumb.url,
              original: image.photo.url
          }
        },
        market: market_price,
        selling: selling_price,
        score: rand(5),
        type: course.type,
        style: course.style,
        proposal: course.proposal,
        seller: {
            mxid: seller_user.profile.mxid,
            name: seller_user.profile.name,
            avatar: seller_user.profile.avatar.thumb.url
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
        service: [1, 2, 3, 4],
        buyers: buyers,
        comments: [
            count: course.comments_count,
            items: comments.take(2)
        ]
    }
    json_hash = json_hash.merge(limit: {start: course.limit_start, end: course.limit_end}) if course.has_attribute?(:limit_start)
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


  def comments
    Comment.where('sku LIKE ?', sku[0, sku.rindex('-')])
  end


  private
  def buyers
    User.where(id: Order.includes(:order_item).where('order_items.sku=?', sku).pluck(:user_id)).map { |user|
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
