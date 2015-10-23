class Like < ActiveRecord::Base
  before_save :within_month
  belongs_to :user
  DYNAMIC = 1
  PERSON = 2

  def as_json
    {
        user: user.summary_json,
        created_at: created_at.localtime.strftime('%Y-%m-%d %H:%M:%S')
    }
  end

  private
  def within_month
    if like_type.eql?(DYNAMIC)
      liked = Like.where(user_id: user_id, liked_id: liked_id, like_type: DYNAMIC).take
      if liked.present?
        errors.add('exist', '您已经对')
        return false
      end
    elsif like_type.eql?(PERSON)
      liked = Like.where(user_id: user_id, liked_id: liked_id, like_type: PERSON, created_at: Time.now.at_beginning_of_month..Time.now).take
      if liked.present?
        errors.add('exist', '您本月已经对该用户点过赞')
        return false
      end
    end
  end
end
