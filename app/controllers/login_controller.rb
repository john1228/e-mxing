class LoginController < ApplicationController
  def sns
    user = sns_login(params[:sns], params[:code])
    if user.blank?
      render json: Failure.new('第三方登录失败')
    else
      render json: {code: 0, message: '该用户已经被用户举报封存，如有疑问，可联系客服人员咨询解封'} if Blacklist.find_by(user: user).present?
      Rails.cache.write(user.token, user)
      render json: Success.new(user: user.summary_json)
    end
  end

  private
  def sns_login(sns, code)
    case sns
      when 'qq'
        oauth_consumer_key = '1103429959'
        host = 'https://graph.qq.com/'
        conn = Faraday.new(:url => host)
        #获取ME
        me = conn.get 'oauth2.0/me', access_token: code
        me_json = JSON.parse(me.body.gsub('callback( ', '').gsub(');', ''))
        openid = me_json['openid']
        #获取用户信息
        userinfo_response = conn.get 'user/get_info', access_token: code, oauth_consumer_key: oauth_consumer_key, openid: openid
        logger.info userinfo_response.body
        user_info = JSON.parse(userinfo_response.body)
        sns_key = "QQ_#{user_info['seqid']}"
        user = User.find_by(sns: sns_key)
        logger.info user.present?
        if user.nil?
          user = User.new(
              mobile: SecureRandom.uuid, sns: sns_key, name: user_info['data']['nick'], avatar: user_info['data']['head']+'/100',
              birthday: "#{user_info['data']['birth_year']}-#{user_info['data']['birth_month']}-#{user_info['data']['birth_day']}",
              signature: '', gender: user_info['data']['sex'].eql?('1') ? 0 : 1, address: user_info['data']['location']
          )
          user.save
        end
        user
      when 'weixin'
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
        logger.info user_info
        sns_key = "WeChat_#{user_info['openid']}"
        user = User.find_by(sns: sns_key)
        if user.nil?
          user = User.new(
              mobile: SecureRandom.uuid, sns: sns_key, name: user_info['nickname'], avatar: user_info['headimgurl'],
              signature: '', gender: user_info['sex'].eql?('1') ? 0 : 1, address: "#{user_info['province']}#{user_info['city']}"
          )
          user.save
        end
        user
      when 'sina'
        #获取UID
        host = 'https://api.weibo.com'
        conn = Faraday.new(:url => host)
        response = conn.get '2/account/get_uid.json', access_token: code
        uid_json = JSON.parse(response.body)
        #TO: 获取用户信息
        userinfo_response = conn.get '2/users/show.json', access_token: code, uid: uid_json['uid']
        user_info = JSON.parse(userinfo_response.body)
        sns_key = "sina_#{user_info['id']}"
        user = User.find_by(sns: sns_key)
        if user.nil?
          user = User.new(
              mobile: SecureRandom.uuid, sns: sns_key, name: user_info['screen_name'], avatar: user_info['avatar_hd'],
              signature: user_info['description'], gender: user_info['gender'].eql?('m') ? 0 : 1, address: user_info['location']
          )
          user.save
        end
        user
    end
  end
end