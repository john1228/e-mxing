class OrderItem < ActiveRecord::Base
  self.inheritance_column = nil
  belongs_to :order
  belongs_to :course, counter_cache: true

  def as_json
    {
        id: course_id,
        name: name,
        cover: cover,
        type: type,
        price: price.to_i,
        during: during,
        amount: amount,
        guarantee: course.guarantee
    }
  end
end
