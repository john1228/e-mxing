class Schedule < ActiveRecord::Base
  belongs_to :coach
  belongs_to :course, class: Sku, foreign_key: :sku_id
  enum user_type: [:platform, :member]

  validates_presence_of :start,message: '未设置开始时间'
  validates_presence_of :end,message: '未设置结束时间'
end
