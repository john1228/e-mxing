class MessageJob < ActiveJob::Base
  queue_as :default

  def perform(user_id, mobile)
    #TODO 发送推送消息和手机短信息 
  end
end
