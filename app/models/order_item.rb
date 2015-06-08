class OrderItem < ActiveRecord::Base
  belongs_to :order

  def as_json
    {
        name: name,
        cover: cover.thumb.url,
        price: price,
        amount: amount
    }
  end
end
