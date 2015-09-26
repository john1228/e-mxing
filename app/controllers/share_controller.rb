class ShareController < ApplicationController
  def dynamic
    @dynamic = Dynamic.find_by(id: params[:id])
    @user = @dynamic.user
    seconds = Time.now - @dynamic.created_at
    if seconds <60
      @created_string = '刚刚'
    elsif seconds< 60*60
      @created_string = "#{(seconds/60).to_i}分钟"
    elsif seconds< 60*60*24
      @created_string = "#{(seconds/(60*60)).to_i}小时前"
    elsif seconds < 60*60*24*7
      @created_string = "#{(seconds/(60*60*24)).to_i}天前"
    elsif seconds< 60*60*24*30
      @created_string = "#{(seconds/(60*60*24*7)).to_i}周前"
    elsif seconds < 60*60*24*365
      @created_string = "#{(seconds/(60*60*24*30)).to_i}月前"
    else
      @created_string = "#{(seconds/(60*60*24*365)).to_i}年前"
    end
    @dynamic_film = @dynamic.dynamic_film
    @dynamic_images = @dynamic.dynamic_images
    @comments = @dynamic.dynamic_comments
    render layout: false
  end

  def service
    @service = Service.find_by_mxid(params[:id])
    @coaches = @service.coaches.take(8)
    @photos = @service.service_photos.order(id: :desc).take(8)
    @courses = Course.where(status: Course::STATUS[:online], coach_id: @service.coaches.pluck(:id)).take(4)
    render layout: false
  end


  def agency
    service = Service.find_by_mxid(10023)
    in_the_sale = Sku.online.where(seller_id: service.coaches.pluck(:id)<<service.id)
    detail = {
        mxid: service.profile.mxid,
        name: service.profile.name,
        avatar: service.profile.avatar.thumb.url,
        views: service.views,
        address: service.profile.address,
        coordinate: {
            lng: service.place.lonlat.x,
            lat: service.place.lonlat.y
        },
        coach: {
            amount: service.coaches.count,
            item: service.coaches.limit(10).map { |coach|
              {
                  mxid: coach.profile.mxid,
                  name: coach.profile.name,
                  avatar: coach.profile.avatar.thumb.url,
                  background: (coach.photos.first.thumb.url rescue ''),
                  score: coach.score,
                  likes: coach.likes.count,
                  dynamics: coach.dynamics.count,
                  course: Sku.online.where('skus.sku LIKE ?', 'CC%').where(seller_id: coach.id).count
              }
            }
        },
        course: {
            amount: in_the_sale.count,
            item: in_the_sale.order(updated_at: :desc).limit(10).map { |item|
              {
                  name: item.course_name,
                  cover: item.course_cover,
                  market: item.market_price,
                  selling: item.selling_price.to_i,
                  sold: item.orders_count,
                  score: item.score,
                  during: item.course.during,
                  exp: {
                      year: Date.today.next_day(item.course.exp).year,
                      month: Date.today.next_day(item.course.exp).month,
                      day: Date.today.next_day(item.course.exp).day
                  },
                  comment: {
                      amount: item.comments_count,
                      item: item.comments.limit(1).map { |comment|
                        {
                            content: comment.content,
                            created: comment.created_at.localtime.strftime('%Y-%m-%d'),
                            user: {
                                name: comment.user.profile.name,
                                avatar: comment.user.profile.avatar
                            }
                        }
                      }
                  }
              }
            }
        },
        photowall: service.photos.map { |photo| photo.photo.thumb.url }
    }
    response.headers['Access-Control-Allow-Origin'] = '*'
    render json: Success.new(service: detail)
  end


  def course
    sku = params[:id]
    @sku = Sku.find_by(sku: sku)
    @course = @sku.course
    @services = sku.start_with?('CC') ? @sku.seller_user.service.profile.service : @sku.seller_user.profile.service
    @buyers = User.where(id: Order.includes(:order_item).where('orders.status = ? and order_items.sku LIKE ?', Order::STATUS[:pay], sku[0, sku.rindex('-')] + '%').order(id: :desc).limit(5).pluck(:user_id))
    @comment_count = @sku.comments.count
    @image_comments = @sku.image_comments.take(5)
    choose = INTERESTS['items'].detect { |item| item['id']==@course.type }
    @type_name = choose['name']
    @expired_date = Date.today.next_day(@course.exp)
    render layout: false
  end
end
