namespace :sns do
  desc '计算周like榜'
  task :sina do
    host = 'https://api.weibo.com'
    conn = Faraday.new(:url => host)
    response = conn.get '2/account/get_uid.json', access_token: '2.004Da7PBuIid8Df58c7a9ba4fTyZHB'
    puts response.body

    conn = Faraday.new(:url => host)
    userinfo_response = conn.get '2/users/show.json', access_token: '2.004Da7PBuIid8Df58c7a9ba4fTyZHB', uid: 1144112993
    puts userinfo_response.body
  end
end