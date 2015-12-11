class Schedule < ActiveRecord::Base
  belongs_to :coach
  belongs_to :course, class: Sku, foreign_key: :sku_id
end
