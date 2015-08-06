class ServiceCourse < ActiveRecord::Base
  self.inheritance_column = nil
  STATUS = {offline: 0, online: 1}
  attr_accessor :agency, :market_price, :selling_price, :store, :limit, :limit_time
  after_update :skus_build
  validates_presence_of :name, :type, :style, :during, :proposal, :exp, :intro

  mount_uploaders :image, PhotoUploader

  def cover
    image[0].thumb.url
  end

  private
  def skus_build
    Sku.destroy_all("sku LIKE 'SC%' and course_id = #{id}")
    if status.eql?(STATUS[:online])
      agencies = Service.where(id: agency)
      agencies.each { |agency|
        Sku.create(
            sku: 'SC'+'-' + '%06d' % id + '-' + '%06d' % (agency.id),
            course_id: id,
            course_id: id,
            course_type: type,
            course_name: name,
            course_cover: cover,

            seller: agency.profile.name,
            seller_id: agency.id,
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
end
