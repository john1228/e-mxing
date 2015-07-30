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
    {
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
            mxid: seller_user.mxid,
            name: seller_user.profile.name,
            avatar: seller_user.profile.thumb.url
        },
        address: [{
                      name: address,
                      coordinate: {
                          lng: coordinate.x,
                          lat: coordinate.y
                      }
                  }],
        info: course.info,
        special: course.special,
        service: [1, 2, 3, 4],
        buyers: buyers,
        comments: [
            count: course.comments_count,
            items: course.comments.take(2)
        ]
    }
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
      user = Enthusiast.find_by(id: seller_id)
    end
    user
  end

  def course
    if sku.start_with?('SC')
      ServiceCourse.find_by(id: course_id)
    else
      Course.find_by(id: course_id)
    end
  end

end
