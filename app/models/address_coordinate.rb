class AddressCoordinate < ActiveRecord::Base
  scope :nearby, ->(lng, lat, page=1) {
    select("select st_distance(address_coordinates.lonlat, 'POINT(#{lng} #{lat})') as distance")
    find_by_sql("select st_distance(address_coordinates.lonlat, 'POINT(#{lng} #{lat})') as distance from address_coordinates,courses where st_dwithin(address_coordinates.lonlat, 'POINT(#{lng} #{lat})',150000) and courses.address=address_coordinates.address_id and #{filters} order by distance asc limit 25 offset (#{page}-1)*25")
  }
end
