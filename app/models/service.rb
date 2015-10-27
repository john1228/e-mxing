class Service<User
  default_scope { joins(:profile).where('profiles.identity' => 2) }
  after_save :location
  has_many :service_members, dependent: :destroy
  has_many :service_photos, foreign_key: :user_id, dependent: :destroy
  has_many :service_dynamics, foreign_key: :user_id, dependent: :destroy

  has_many :service_members, dependent: :destroy
  has_many :coaches, through: :service_members
  alias_attribute :service_id, :id

  def as_json
    in_the_sale = Sku.online.where(seller_id: coaches.pluck(:id)<<id)
    top_sellers = in_the_sale.where('skus.sku LIKE ?', 'CC%').order(orders_count: :desc).order(id: :asc).pluck(:seller_id).uniq[0, 3]
    tops = coaches.where(id: top_sellers)
    tops += coaches.where.not(id: top_sellers).order(id: :desc).take(3-tops.length) unless tops.length.eql?(3)
    {
        mxid: profile.mxid,
        name: profile.name,
        avatar: profile.avatar.thumb.url,
        address: profile.province.to_s + profile.city.to_s + profile.address.to_s,
        distance: (attributes['distance']||0).to_i,
        coach: {
            amount: coaches.count,
            top: tops.map { |top| top.summary_json }
        },
        sale: {
            amount: in_the_sale.count,
            sold: in_the_sale.sum(:orders_count),
            floor_price: (in_the_sale.order(selling_price: :asc).first.selling_price.to_i rescue 0)
        }
    }
  end

  def detail
    in_the_sale = Sku.online.where(seller_id: coaches.pluck(:id)<<id)
    detail = {
        mxid: profile.mxid,
        name: profile.name,
        avatar: {
            thumb: profile.avatar.thumb.url,
            origin: profile.avatar.url
        },
        views: views,
        address: profile.address,
        coordinate: {
            lng: place.lonlat.x,
            lat: place.lonlat.y
        },
        intro: profile.signature,
        coach: {
            amount: coaches.count,
            item: coaches.map { |coach| coach.summary_json.merge(
                likes: coach.likes.count
            ) }
        },
        dynamics: dynamics.count,
        course: {
            amount: in_the_sale.count,
            item: in_the_sale.order(updated_at: :desc).take(2)
        },
        open: '8:30-21:30',
        service: _service,
        facility: profile.service,
        contact: profile.mobile,
        photowall: photos.map { |photo| {
            no: photo.id,
            thumb: photo.photo.thumb.url,
            original: photo.photo.url
        } }
    }

    detail = detail.merge(showtime: {
                              id: showtime.id,
                              cover: showtime.dynamic_film.cover.url,
                              film: showtime.dynamic_film.film.hls
                          }) if showtime.present?
    detail
  end

  private
  def _service
    choose_interests = INTERESTS['items'].select { |item| profile.hobby.include?(item['id']) }
    choose_interests.collect { |choose| choose['name'] }
  end

  def location
    conn = Faraday.new(:url => 'http://api.map.baidu.com')
    address_summary = ((profile.province.to_s + profile.city.to_s + profile.address.to_s).match(/(.+?)[弄号]/)).to_s
    result = conn.get '/geocoder/v2/', address: address_summary.blank? ? address : address_summary, output: 'json', ak: '61Vl2dO7CKCt0rvLKQiePGT5'
    json_string = JSON.parse(result.body)
    bd_lng = json_string['result']['location']['lng']
    bd_lat = json_string['result']['location']['lat']
    if place.nil?
      create_place(lonlat: gcj_02(bd_lng, bd_lat))
    else
      place.update(lonlat: gcj_02(bd_lng, bd_lat))
    end
    #更新机构课程课程的地址
    Sku.where(service_id: id).update_all(address: profile.province.to_s + profile.city.to_s + profile.address.to_s, coordinate: gcj_02(bd_lng, bd_lat))
  end

  def gcj_02(bd_lng, bd_lat)
    x, y = bd_lng - 0.0065, bd_lat - 0.006
    z = Math.sqrt(x * x + y * y) - 0.00002 * Math.sin(y * Math::PI)
    theta = Math.atan2(y, x) - 0.000003 * Math.cos(x * Math::PI)
    "POINT(#{z * Math.cos(theta)} #{z * Math.sin(theta)})"
  end
end
