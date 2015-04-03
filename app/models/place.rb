class Place < ActiveRecord::Base
  scope :nearby, ->(lng, lat) { select("user_id, st_distance(lonlat, 'POINT(#{lng} #{lat})') as distance").where("st_dwithin(lonlat, 'POINT(#{lng} #{lat})',150000)").order('distance') }
  scope :nearby_persons, ->(lng, lat) { select("profiles.*,st_distance(places.lonlat, 'POINT(#{lng} #{lat})') as distance").joins(:profile).where("profiles.identity!=2 and st_dwithin(places.lonlat, 'POINT(#{lng} #{lat})',150000)").order('distance') }
  scope :nearby_services, ->(lng, lat) { select("profiles.*,st_distance(places.lonlat, 'POINT(#{lng} #{lat})') as distance").joins(:profile).where("profiles.identity=2 and st_dwithin(places.lonlat, 'POINT(#{lng} #{lat})',150000)").order('distance') }

  belongs_to :user

  belongs_to :profile, foreign_key: :user_id

  set_rgeo_factory_for_column(:lonlat, RGeo::Geographic.spherical_factory(:srid => 4326))
end
