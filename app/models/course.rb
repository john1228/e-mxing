class Course < ActiveRecord::Base
  self.inheritance_column = nil
  belongs_to :coach
  has_many :course_photos, dependent: :destroy
  has_many :comments, dependent: :destroy

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
        address: school_addresses
    }
  end

  def school_addresses
    coach.addresses.where(id: address.split(',').map { |id| id.to_i }).map { |address|
      {
          venus: address.venues,
          address: address.city + address.address
      }
    }
  end
end
