class Like < ActiveRecord::Base
  before_save :within_month
  DYNAMIC = 1
  PERSON = 2


  private
  def within_month
    liked = Like.where(user_id: user_id, liked_id: liked_id, like_type: PERSON, created_at: Time.now.at_beginning_of_month..Time.now).take
    return false if liked.present?
  end
end
