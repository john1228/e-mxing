class AddressCoordinate < ActiveRecord::Base
  has_many :course_addresses, foreign_key: :address_id
  scope :nearby, ->(lng, lat, page=1) {
    select("st_distance(address_coordinates.lonlat, 'POINT(#{lng} #{lat})') distance").joins(:course_addresses).where("st_dwithin(address_coordinates.lonlat, 'POINT(#{lng} #{lat})', 150000) and course_addresses.address_id=address_coordinates.address_id").page(page)
  }
end
