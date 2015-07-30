class Sku < ActiveRecord::Base
  scope :nearby, ->(lng, lat, filters, page=1) { find_by_sql("select profiles.*,st_distance(places.lonlat, 'POINT(#{lng} #{lat})') as distance from profiles,places where  st_dwithin(places.lonlat, 'POINT(#{lng} #{lat})',15000000) and profiles.user_id=places.user_id and #{filters} order by distance asc") }

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
        images: course.images,
        market: market_price,
        selling: selling_price,
        type: course.type,
        style: course.style,
        proposal: course.proposal,
    }
  end

  def seller

  end

  def course
    if sku.start_with?('SC')
      ServiceCourse.find_by(id: course_id)
    else
      Course.find_by(id: course_id)
    end
  end

  private
  def seller

  end
end
