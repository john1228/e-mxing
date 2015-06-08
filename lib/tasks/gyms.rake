namespace :gyms do
  desc '课程情况'
  task :courses do
    conn = Faraday.new(:url => 'http://192.168.0.126')
    conn.headers[:token] = '65b9eea6e1cc6bb9f0cd2a47751a186f'
    response = conn.get '/gyms/courses', coach: 10099
    puts response.body
  end

  desc '购买课程'
  task :courses_buy do
    conn = Faraday.new(:url => 'http://192.168.0.126')
    conn.headers[:token] = 'a87ff679a2f3e71d9181a67b7542122c'
    response = conn.post '/gyms/courses', contact_name: '小万万', contact_phone: '13585753578', pay_type: 1, item: '1:8'
    puts response.body
  end


  #预约团操
end