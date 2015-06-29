class Course < ActiveRecord::Base
  self.inheritance_column = nil
  belongs_to :coach
  has_many :course_photos, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :lessons, dependent: :destroy
  has_many :concerns, class: Concerned, dependent: :destroy
  has_many :course_abstracts, dependent: :destroy
  has_many :order_items
  attr_accessor :address
  STATUS = {delete: 0, online: 1}
  STYLE = {many: '团操', one: '1v1'}
  GUARANTEE = 1

  after_save :update_course_abstract

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
        images: course_photos.collect { |course_photo| course_photo.photo.thumb.url },
        purchased: order_items.count
    }
  end

  def cover
    if course_photos.blank?
      ''
    else
      course_photos.first.photo.thumb.url
    end
  end

  def school_addresses
    course_abstracts.map { |course_abstract|
      address = course_abstract.address
      {
          id: address.id,
          venues: address.venues,
          address: address.city + address.address
      }
    }
  end

  private
  def update_course_abstract
    if address.present?
      CourseAbstract.delete_all(course_id: id)
      address.each { |address_id|
        CourseAbstract.create(course_id: id, address_id: address_id, coach_id: coach.id,
                              coach_gender: coach.profile.gender, course_price: price, course_type: type,
                              coordinate: AddressCoordinate.find_by(address_id: address_id).lonlat)
      }
    end
  end
end
