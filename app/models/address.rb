class Address < ActiveRecord::Base
  before_save :build_place_coordinate
  has_one :place, class_name: AddressCoordinate, dependent: :destroy

  def as_json
    {
        id: id,
        venues: venues,
        address: city + address
    }
  end

  private
  def build_place_coordinate
    begin
      conn = Faraday.new(:url => 'http://api.map.baidu.com')
      result = conn.get '/geocoder/v2/', address: city + address, output: 'json', ak: '61Vl2dO7CKCt0rvLKQiePGT5'
      json_string = JSON.parse(result.body)
      build_place(lonlat: "POINT(#{json_string['result']['location']['lng']} #{json_string['result']['location']['lat']})")
    rescue
      false
    end
  end
end
