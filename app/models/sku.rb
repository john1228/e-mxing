class Sku < ActiveRecord::Base
  belongs_to :course
  belongs_to :service_course
end
