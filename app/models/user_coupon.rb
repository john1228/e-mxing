class UserCoupon < ActiveRecord::Base
  belongs_to :user
  belongs_to :coupon
end
