class OrderItem < ActiveRecord::Base
  self.inheritance_column = nil
  belongs_to :order
  belongs_to :course

  def as_json
    {
        name: name,
        cover: cover,
        type: type,
        price: price,
        during: during,
        amount: amount,
        guarantee: course.guarantee
    }
  end
end
