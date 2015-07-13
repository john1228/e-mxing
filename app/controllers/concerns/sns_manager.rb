module SnsManager
  extend ActiveSupport::Concern

  def webchat(code)
    #TO: 获取AccessToken
    appid = 'wxcf5397f869f11922'
    secret = 'd1df9bb3aa1954f501814a40175a4f31'
    grant_type = 'authorization_code'
    host = 'https://api.weixin.qq.com'
    conn = Faraday.new(:url => host)
    access_response = conn.get 'sns/oauth2/access_token', appid: appid, secret: secret, code: code, grant_type: grant_type
    access_token = JSON.parse(access_response.body)['access_token']
    #TO: 获取用户信息
    userinfo_response = conn.get 'sns/userinfo', access_token: access_token, openid: appid
    user_info = JSON.parse(userinfo_response.body)
    sns_key = "webchat_#{user_info['openid']}"
    user = User.find_by(sns: sns_key)
    user.create(
        mobile: SecureRandom.uuid, sns: sns_key, name: user_info['nickname'], avatar: user_info['headimgurl'],
        signature: '', gender: user_info['sex'].eql?('1') ? 0 : 1, address: "#{user_info['province']}#{user_info['city']}"
    ) if user.nil?
    user
  end

  def sina(code)
    #TO: 获取AccessToken
    client_id = 3156824048
    client_secret = 'daf17bdcbf3000a284ab196c5efba9e3'
    grant_type = 'authorization_code'
    host = 'https://api.weibo.com'
    redirect_uri = 'http://www.e-mxing.com'
    conn = Faraday.new(:url => host)
    response = conn.get 'oauth2/access_token', client_id: client_id, client_secret: client_secret, grant_type: grant_type, code: code,
                        redirect_uri: redirect_uri
    access_token = JSON.parse(response.body)['access_token']
    #TO: 获取用户信息
    userinfo_response = conn.get '2/users/show.json', access_token: access_token
    user_info = JSON.parse(userinfo_response.body)
    sns_key = "sina_#{user_info['id']}"
    user = User.find_by(sns: sns_key)
    user = User.create(
        mobile: SecureRandom.uuid, sns: sns_key, name: user_info['screen_name'], avatar: user_info['avatar_hd'],
        signature: user_info['description'], gender: user_info['gender'].eql?('m') ? 0 : 1, address: user_info['location']
    ) if user.nil?
    user
  end

  def qq(code)
    oauth_consumer_key = '1103429959'
    host = 'https://graph.qq.com/'
    conn = Faraday.new(:url => host)
    #获取ME
    me = conn.get 'oauth2.0/me', access_token: code
    me_json = JSON.parse(me.body.gsub('callback( ', '').gsub(');', ''))
    openid = me_json['openid']
    #获取用户信息
    userinfo_response = conn.get 'user/get_info', access_token: code, oauth_consumer_key: oauth_consumer_key, openid: openid
    user_info = JSON.parse(userinfo_response.body)
    sns_key = "qq_#{user_info['seqid']}"
    user = User.find_by(sns: sns_key)
    user = User.create(
        mobile: SecureRandom.uuid, sns: sns_key, name: user_info['nick'], avatar: user_info['head'],
        birthday: "#{user_info['birth_year']}-#{user_info['birth_month']}-#{user_info['birth_day']}",
        signature: '', gender: user_info['sex'].eql?('1') ? 0 : 1, address: user_info['location']
    ) if user.nil?
    user
  end

end