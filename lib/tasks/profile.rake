namespace :profile do
  desc '我的资料'
  task :show do
    host = 'http://localhost'
    conn = Faraday.new(:url => host)
    conn.headers['token'] = 'a87ff679a2f3e71d9181a67b7542122c'
    response = conn.get '/profile', mxid: 10001
    puts response.body
  end


  desc '测试更新'
  task :update => :environment do
    host = 'http://localhost'
    conn = Faraday.new(:url => host) do |f|
      f.request :multipart
      f.request :url_encoded
      f.adapter :net_http
    end
    conn.headers['token'] = 'a87ff679a2f3e71d9181a67b7542122c'
    response = conn.post '/profile', avatar: Faraday::UploadIO.new("/root/桌面/images/024f78f0f736afc3e9876f57b019ebc4b745127c.jpg", 'image/jpeg')
    puts "<<<#{response.body}"
  end

end