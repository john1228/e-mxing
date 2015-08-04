class OrderItem < ActiveRecord::Base
  self.inheritance_column = nil
  belongs_to :order
  belongs_to :sku_info, class_name: Sku, counter_cache: true

  def as_json
    {
        sku: sku,
        name: name,
        cover: cover,
        type: type,
        price: price.to_i,
        during: during,
        amount: amount,
        guarantee: sku_info.course.guarantee
    }
  end
end
