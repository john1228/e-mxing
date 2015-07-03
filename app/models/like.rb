class Like < ActiveRecord::Base
  before_save :within_month
  DYNAMIC = 1
  PERSON = 2


  private
  def within_month
    liked = Like.where(user_id: user_id, liked_id: liked_id, like_type: Like::PERSON, created_at: Time.now.at_beginning_of_month..Time.now).take
    if liked.present?
      errors.add('exist','用户已存在')
      return false
    end
  end
end
