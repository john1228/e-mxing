class Like < ActiveRecord::Base
  before_save :within_month
  belongs_to :user
  enum like_type: {dynamic: 1, person: 2}

  def as_json
    {
        user: user.summary_json,
        created_at: created_at.localtime.strftime('%Y-%m-%d %H:%M:%S')
    }
  end

  private
  def within_month
    if dynamic?
      liked = Like.dynamic.find_by(user_id: user_id, liked_id: liked_id)
      if liked.present?
        errors.add('exist', '您已经对该动态点过赞')
        return false
      end
    elsif person?
      liked = Like.person.where(user_id: user_id, liked_id: liked_id, created_at: Time.now.at_beginning_of_month..Time.now).take
      if liked.present?
        errors.add('exist', '您本月已经对该用户点过赞')
        return false
      end
    end
  end
end
