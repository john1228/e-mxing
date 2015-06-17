class Course < ActiveRecord::Base
  self.inheritance_column = nil
  belongs_to :coach
  has_many :course_photos, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :lessons, dependent: :destroy
  has_many :concerned, class: Concerned, dependent: :destroy
  has_many :course_addresses, dependent: :destroy
  attr_accessor :address
  STATUS = {delete: 0, online: 1}
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
        address: school_addresses,
        images: course_photos.collect { |course_photo| course_photo.photo.thumb.url },
        purchased: OrderItem.where(course_id: id).count
    }
  end


  def school_addresses
    coach.addresses.where(id: CourseAbstract.pluck(:address_id)).map { |address|
      {
          venus: address.venues,
          address: address.city + address.address
      }
    }
  end

  private
  def update_course_abstract
    CourseAbstract.delete_all(course_id: id)
    address.each { |address_id|
      CourseAbstract.create(course_id: id, address_id: address_id, coach: coach.id,
                            coach_gender: coach.profile.gender, course_price: price, course_type: type,
                            coordinate: AddressCoordinate.find_by(address_id: address_id).lonlat)
    }
  end
end
