class ServiceCourse < ActiveRecord::Base
  self.inheritance_column = nil
  STATUS = {offline: 0, online: 1}
  attr_accessor :agency, :market_price, :selling_price, :store, :limit, :image, :limit_time
  after_save :skus_build
  validates_presence_of :name, :type, :style, :during, :proposal, :exp, :info

  def cover
    ''
  end

  private
  def skus_build
    Sku.destroy_all("sku LIKE 'SC%' and course_id = #{id}")
    agencies = Service.where(id: agency)
    agencies.each { |agency|
      Sku.create(
          sku: 'SC'+'-' + '%06d' % id + '-' + '%06d' % (agency.id),
          course_id: id,
          market_price: market_price,
          selling_price: selling_price,
          store: store,
          limit: limit,
          address: agency.address||'',
          coordinate: (agency.place.lonlat rescue 'POINT(0 0)')
      )
    }
  end
end
