class Like < ActiveRecord::Base
  before_save :within_month
  after_save :send_message


  DYNAMIC = 1
  PERSON = 2


  private
  def within_month
    liked = Like.where(created_at: Time.now.at_beginning_of_month..Time.now).take
    return false if liked.present?
  end
  #TODO: 发送消息给被赞到人
  def send_message

  end
end
