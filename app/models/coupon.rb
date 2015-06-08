class Coupon < ActiveRecord::Base
  #优惠范围(通用,限制私教,限制产品,限制服务号)
  TYPE = {general: 1, gyms: 2, course: 3, service: 4}
end
