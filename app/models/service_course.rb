class ServiceCourse < ActiveRecord::Base
  self.inheritance_column = nil
  STATUS = {offline: 0, online: 1}
  attr_accessor :agency, :coach, :market_price, :selling_price, :store, :limit, :limit_time
  after_create :generate_sku
  after_update :online_or_offline
  validates_presence_of :name, :type, :style, :during, :proposal, :exp, :intro

  mount_uploaders :image, ImagesUploader

  def cover
    image.first.url
  end

  def type_name
    (INTERESTS['items'].detect { |item| item['id']==type })['name']
  end


  def offline
    update(status: STATUS[:offline])
  end

  private
  def generate_sku
    agencies = Service.where(id: agency)
    agencies.each { |agency|
      Sku.create(
          sku: 'SC'+'-' + '%06d' % id + '-' + '%06d' % (agency.id),
          service_id: agency.id,
          course_id: id,
          course_type: type,
          course_name: name,
          course_during: during,

          seller: (Profile.find_by(user_id: coach).name rescue agency.profile.name),
          seller_id: coach||agency.id,
          market_price: market_price,
          selling_price: selling_price,
          store: store,
          limit: limit,
          status: status,
          address: (agency.profile.province.to_s + agency.profile.city.to_s + agency.profile.address.to_s),
          coordinate: (agency.place.lonlat rescue 'POINT(0 0)')
      )
    }
  end

  def online_or_offline
    if status.eql?(STATUS[:online])
      Sku.where("sku LIKE 'SC%' and course_id = #{id}").map { |item| item.update(status: STATUS[:online], course_cover: cover) }
    else
      Sku.where(course_id: id).update_all(status: STATUS[:offline])
    end
  end
end
