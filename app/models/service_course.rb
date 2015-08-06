class ServiceCourse < ActiveRecord::Base
  self.inheritance_column = nil
  STATUS = {offline: 0, online: 1}
  attr_accessor :agency, :market_price, :selling_price, :store, :limit, :limit_time
  after_create :generate_sku
  after_update :online_or_offline
  validates_presence_of :name, :type, :style, :during, :proposal, :exp, :intro

  mount_uploaders :image, PhotoUploader

  def cover
    image[0].thumb.url
  end

  private
  def generate_sku
    agencies = Service.where(id: agency)
    agencies.each { |agency|
      Sku.create(
          sku: 'SC'+'-' + '%06d' % id + '-' + '%06d' % (agency.id),
          course_id: id,
          course_type: type,
          course_name: name,
          course_cover: image[0].thumb.url,

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

  def online_or_offline
    if status.eql?(STATUS[:online])
      Sku.where("sku LIKE 'SC%' and course_id = #{id}").update_all(status: STATUS[:online])
    else
      Sku.where("sku LIKE 'SC%' and course_id = #{id}").update_all(status: STATUS[:offline])
    end
  end
end
