namespace :sns do
  desc '计算周like榜'
  task :qq => :environment do
    code = '47C55881DFAB0DA50465C2B1E73A6515'
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
    puts user_info
  end
end