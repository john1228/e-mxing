class Place < ActiveRecord::Base
  scope :nearby, ->(lng, lat, filters, page=1) { find_by_sql("select profiles.*,st_distance(places.lonlat, 'POINT(#{lng} #{lat})') as distance from profiles,places where  st_dwithin(places.lonlat, 'POINT(#{lng} #{lat})',15000000) and profiles.user_id=places.user_id and #{filters} order by distance asc limit 20 offset (#{page}-1)*20") }
  scope :nearby_services, ->(lng, lat, page=1) { find_by_sql("select profiles.*,st_distance(places.lonlat, 'POINT(#{lng} #{lat})') as distance from profiles,places where profiles.identity=2 and st_dwithin(places.lonlat, 'POINT(#{lng} #{lat})',15000000) and profiles.user_id=places.user_id order by distance asc limit 20 offset (#{page}-1)*20") }

  belongs_to :user
  set_rgeo_factory_for_column(:lonlat, RGeo::Geographic.spherical_factory(:srid => 4326))

  def nearby_user_json
    {
        mxid: 10000 + id,
        name: name||'',
        avatar: $img_host+ '/' + (avatar.blank? ? "/default/user.jpg" : "profile/thumb_#{avatar}"),
        gender: gender||1,
        age: (user_age rescue 15),
        signature: signature,
        tags: user_tags,
        identity: identity,
        distance: distance.to_i
    }
  end

  private
  def user_age
    years = Date.today.year - birthday.year
    years + (Date.today < birthday + years.year ? -1 : 0)
  end

  def user_tags
    [0, identity.eql?(2) ? 1 : 0, identity.eql?(1) ? 1 : 0]
  end
end
