class Address < ActiveRecord::Base
  def as_json
    {
        id: id,
        venues: venues,
        address: city + address
    }
  end
end
