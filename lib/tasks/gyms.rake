namespace :gyms do
  host = 'http://localhost'

  desc '课程情况'
  task :courses do
    conn = Faraday.new(:url => host)
    response = conn.get '/gyms/courses', mxid: 10099
    puts response.body
  end

  desc '购买课程'
  task :courses_buy do
    conn = Faraday.new(:url => host)
    conn.headers[:token] = 'a87ff679a2f3e71d9181a67b7542122c'
    response = conn.post '/gyms/courses', contact_name: '小万万', contact_phone: '13585753578', pay_type: 1, item: '1:8'
    puts response.body
  end


  #预约团操
end