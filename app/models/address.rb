class Address < ActiveRecord::Base
  after_create :build_place

  def as_json
    {
        id: id,
        venues: venues,
        address: city + address
    }
  end

  private
  def build_place

  end
end
