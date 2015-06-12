namespace :gyms do
  host = 'http://stage.e-mxing.com'
  token = 'f0935e4cd5920aa6c7c996a5ee53a70f'

  desc '课程情况'
  task :courses do
    conn = Faraday.new(:url => host)
    conn.headers[:token] = token
    response = conn.get '/gyms/courses', mxid: 10081
    puts response.body
  end

  desc '购买课程'
  task :courses_buy do
    conn = Faraday.new(:url => host)
    conn.headers[:token] = token
    response = conn.post '/gyms/courses', contact_name: '小万万', contact_phone: '13585753578', pay_type: 1, item: '4:8'
    puts response.body
  end

  task :orders do
    conn = Faraday.new(:url => host)
    conn.headers[:token] = '3c59dc048e8850243be8079a5c74d079'
    response = conn.get 'orders'
    puts response.body
  end

  task :lessons do
    conn = Faraday.new(:url => host)
    conn.headers[:token] = token
    response = conn.get 'lessons'
    puts response.body
  end


  #预约团操
end