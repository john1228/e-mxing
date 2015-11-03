class Apply < ActiveRecord::Base
  belongs_to :h_activity, counter_cache: :apply_count
  belongs_to :user

  validates_presence_of :name, message: '请填写您的名字'
  validates_presence_of :phone, message: '请填写您的联系方式'
  validates_uniqueness_of :user_id, scope: :activity_id, message: '您已经报名过该活动'
end