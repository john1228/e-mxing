class ServiceCourse < ActiveRecord::Base
  self.inheritance_column = nil
  STATUS = {offline: 0, online: 1}
  attr_accessor :agency, :market_price, :selling_price, :store, :limit, :limit_time
  after_create :generate_sku
  after_update :online_or_offline
  validates_presence_of :name, :type, :style, :during, :proposal, :exp, :intro

  mount_uploaders :image, PhotosUploader

  def cover
    image.first.thumb.url
  end

  def type_name
    INTERESTS['items'].select { |item| type.eql?(item['id']) }.first['name']
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
      Sku.where("sku LIKE 'SC%' and course_id = #{id}").update_all(status: STATUS[:online], course_cover: cover)
    else
      Sku.where("sku LIKE 'SC%' and course_id = #{id}").update_all(status: STATUS[:offline], course_cover: cover)
    end
  end
end
