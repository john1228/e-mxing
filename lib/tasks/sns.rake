namespace :sns do
  desc '计算周like榜'
  task :sina do
    client_id = 3156824048
    client_secret = 'daf17bdcbf3000a284ab196c5efba9e3'
    grant_type = 'authorization_code'
    host = 'https://api.weibo.com'
    redirect_uri = 'http://www.e-mxing.com'
    conn = Faraday.new(:url => host)
    response = conn.post 'oauth2/access_token', client_id: client_id, client_secret: client_secret, grant_type: grant_type, code: '2.004Da7PBuIid8Df58c7a9ba4fTyZHB',
                         redirect_uri: redirect_uri
    puts response.body
  end
end