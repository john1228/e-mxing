namespace :sns do
  desc '计算周like榜'
  task :qq => :environment do
    code = '38308E7AE37FF416351D0CA464DC80B3'
    oauth_consumer_key = '1103429959'
    conn = Faraday.new(url: 'https://graph.qq.com')
    me = conn.get 'oauth2.0/me', access_token: code
    puts me.body
    me_json = JSON.parse(me.body.gsub('callback( ', '').gsub(');', ''))
    openid = me_json['openid']
    userinfo_response = conn.get 'user/get_user_info ', access_token: code, oauth_consumer_key: oauth_consumer_key, openid: openid
    puts userinfo_response.body
  end

  task :apns => :environment do
    APN.notify_async('39d4bacfc99ed2b7c45591d6e373719dabb4349568912ecad578d37e1d10ece7', {alert: 'Hello, World!', sound: true, badge: 99})
  end
end