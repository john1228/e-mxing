module SnsManager
  extend ActiveSupport::Concern

  def webchat(code)
    appid = 'wxcf5397f869f11922'
    secret = 'd1df9bb3aa1954f501814a40175a4f31'
    code = code
    grant_type = 'authorization_code'
    host = 'https://api.weixin.qq.com'
    conn = Faraday.new(:url => host)
    access_response = conn.get 'sns/oauth2/access_token', appid: appid, secret: secret, code: code, grant_type: grant_type
    access_token = JSON.parse(access_response.body)['access_token']
    #TODO: 获取用户信息
    userinfo_response = conn.get 'sns/userinfo', access_token: access_token, openid: appid
    user_info = JSON.parse(userinfo_response.body)
    sns_key = "webchat_#{user_info['openid']}"
    user = User.find_by(sns: sns_key)
    if user.nil?
      user.create(mobile: SecureRandom.uuid, sns: sns_key,)
    end
  end

  def sina
    client_id = 'wxcf5397f869f11922'
    client_secret = 'd1df9bb3aa1954f501814a40175a4f31'
    grant_type = 'authorization_code'
    host = 'https://api.weibo.com'
    conn = Faraday.new(:url => host)
    response = conn.get 'oauth2/access_token', client_id: client_id, client_secret: client_secret, grant_type: grant_type
    access_token = JSON.parse(response.body)['access_token']
  end

  def qq
    appid = 'wxcf5397f869f11922'
    secret = 'd1df9bb3aa1954f501814a40175a4f31'
    code = '001c02acbd2c3f0d3006ba343d7b635F'
    grant_type = 'authorization_code'
    host = 'https://api.weixin.qq.com'
    conn = Faraday.new(:url => host)
    response = conn.get 'sns/oauth2/access_token', appid: appid, secret: secret, code: code, grant_type: grant_type
    puts response.body
  end
end