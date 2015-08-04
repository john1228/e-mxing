class Concerned < ActiveRecord::Base
  belongs_to :course, counter_cache: :concerns_count
  belongs_to :user
  validates_uniqueness_of :user_id, scope: :sku

  def as_json
    sku_info = Sku.find_by(sku: sku)
    sku_info.as_json.merge(
        address: {
            name: sku_info.address,
            coordinate: {
                lng: sku_info.coordinate.x,
                lat: sku_info.coordinate.y
            }
        }
    )
  end
end
