class GroupPlace < ActiveRecord::Base
  belongs_to :group
  scope :nearby, ->(lon, lat) { select("group_id, st_distance(lonlat, 'POINT(#{lon} #{lat})') as distance").where("st_dwithin(lonlat, 'POINT(#{lon} #{lat})',150000)").order('distance') }
  set_rgeo_factory_for_column(:lonlat, RGeo::Geographic.spherical_factory(:srid => 4326))
end
