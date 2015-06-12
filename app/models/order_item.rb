class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :course

  def as_json
    {
        name: name,
        cover: cover,
        price: price,
        during: during,
        amount: amount
    }
  end
end
