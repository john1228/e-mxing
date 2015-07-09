namespace :sns do

  desc '测试创建'
  task :webchat do
    appid = 'wxcf5397f869f11922'
    secret = 'd1df9bb3aa1954f501814a40175a4f31'
    code = '001c02acbd2c3f0d3006ba343d7b635F'
    grant_type = 'authorization_code'
    host = 'https://api.weixin.qq.com'
    conn = Faraday.new(:url => host)
    response = conn.get 'sns/oauth2/access_token', appid: appid, secret: secret, code: code, grant_type: grant_type
    puts response.body
    access_token = 'OezXcEiiBSKSxW0eoylIeDAWIsbtaRg3anpzt4ZdNX4b_4kri1zgFellg58VYMkUdmS230LMYnIo3HB4IImWWpi74sfvkMHEtmrMvUK8PWn6mxzOCBmrhx6XByK75ldR3cZfR43xLV7TKa7RmRcseg'
    userinfo_response = conn.get 'sns/userinfo', access_token: access_token, openid: appid
    puts userinfo_response.body
  end

  task :body do
    host = 'http://localhost'
    conn = Faraday.new(:url => host)
    conn.post do |req|
      req.url 'upload?device=1'
      req.headers['Content-Type'] = 'application/json'
      req.body = '{"2015-06-05":{"c":{"0":0,"1":10,"2":10,"3":10,"4":10,"5":10,"6":10},"o": [["18:00","18:10"],["18:15","18:30"]]}}'
    end
  end
end