class Service<User
  default_scope { joins(:profile).where('profiles.identity' => 2) }
  after_save :location
  has_many :service_members, dependent: :destroy
  has_many :service_photos, foreign_key: :user_id, dependent: :destroy
  has_many :service_tracks, foreign_key: :user_id, dependent: :destroy
  has_many :service_dynamics, foreign_key: :user_id, dependent: :destroy

  has_many :coaches, through: :service_members, dependent: :destroy
  alias_attribute :service_id, :id

  private
  def location

    if often.present?
      conn = Faraday.new(:url => 'http://api.map.baidu.com')
      result = conn.get '/geocoder/v2/', address: profile_often, output: 'json', ak: '61Vl2dO7CKCt0rvLKQiePGT5'
      json_string = JSON.parse(result.body)
      if place.nil?
        create_place(lonlat: "POINT(#{json_string['result']['location']['lng']} #{json_string['result']['location']['lat']})")
      else
        place.update(lonlat: "POINT(#{json_string['result']['location']['lng']} #{json_string['result']['location']['lat']})")
      end
    end
  end
end