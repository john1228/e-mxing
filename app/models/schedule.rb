class Schedule < ActiveRecord::Base
  belongs_to :coach
  belongs_to :course, class: Sku, foreign_key: :sku_id
  enum user_type: [:platform, :member]

  validates_presence_of :start, message: '未设置开始时间'
  validates_presence_of :end, message: '未设置结束时间'

  def user_name
    if user_id.present?
      if platform?
        User.find(user_id).profile.name
      elsif member?
        Member.find(user_id).name
      end
    else
      ''
    end

  end
end
