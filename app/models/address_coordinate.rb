class AddressCoordinate < ActiveRecord::Base
  scope :nearby, ->(lng, lat, page=1) {
    find_by_sql("select st_distance(address_coordinates.lonlat, 'POINT(#{lng} #{lat})')  distance,courses.id course_id,courses.name course_name,courses.during course_during,courses.price course_price,courses.type course_type,courses.style course_style,courses.guarantee course_guarantee from address_coordinates,courses where st_dwithin(address_coordinates.lonlat, 'POINT(#{lng} #{lat})',150000) and address_coordinates.address_id = ANY(courses.address) order by distance asc limit 25 offset (#{page}-1)*25")
  }
end
