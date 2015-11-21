class OrderItem < ActiveRecord::Base
  self.inheritance_column = nil
  belongs_to :order

  def as_json
    {
        sku: sku,
        name: name,
        cover: cover,
        type: type,
        price: price,
        during: during,
        amount: amount
    }
  end
end
