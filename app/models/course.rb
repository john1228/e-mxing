class Course < ActiveRecord::Base
  self.inheritance_column = nil
  belongs_to :coach
  has_many :images, class_name: CoursePhoto, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :lessons, dependent: :destroy
  has_many :concerns, class_name: Concerned, dependent: :destroy
  #has_many :course_abstracts, dependent: :destroy
  has_many :order_items
  attr_accessor :address
  after_save :skus_build

  STATUS = {offline: 0, online: 1}
  GUARANTEE = 1


  def as_json
    {
        id: id,
        name: name,
        type: type,
        style: style,
        during: during,
        price: price,
        exp: exp,
        proposal: proposal,
        intro: intro,
        guarantee: guarantee,
        address: school_addresses,
        images: images.collect { |photo| photo.photo.thumb.url },
        purchased: order_items_count,
        concerns: concerns_count
    }
  end

  def cover
    photos.first.photo.thumb.url rescue ''
  end

  def school_addresses
    [
        {
            venues: coach.service.profile.name,
            address: coach.service.profile.address
        }
    ]
  end

  private
  def sku_build
    Sku.destroy_all("sku LIKE 'CC%' and course_id = #{id}")
    Sku.create(
        sku: 'CC'+'-' + '%06d' % id + '-' + '%06d' % (service.id),
        course_id: id,
        seller: coach.profile.name,
        seller_id: coach.id,
        market_price: price,
        selling_price: price,
        address: service.address||'',
        coordinate: (service.place.lonlat rescue 'POINT(0 0)')
    )
  end
end
