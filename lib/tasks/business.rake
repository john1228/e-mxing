namespace :business do
  host = 'http://stage.e-mxing.com'
  token = '3c59dc048e8850243be8079a5c74d079'

  desc '登录'
  task :login do
    conn = Faraday.new(:url => host)
    response = conn.post '/business/login', username: 18221058659, password: 12345678
    puts response.body
  end

  desc ''
  task :addresses do
    conn = Faraday.new(:url => host)
    conn.headers[:token] = token
    response = conn.get '/business/addresses'
    puts response.body
  end

  task :address_create do
    conn = Faraday.new(:url => host)
    conn.headers[:token] = token
    response = conn.post '/business/addresses', venues: '美型健身房', city: '上海', address: '中山西路933号1206-1208室'
    puts response.body
  end


  desc ''
  task :courses do
    conn = Faraday.new(:url => host)
    conn.headers[:token] = token
    response = conn.get '/business/courses'
    puts response.body
  end

  task :course_create do
    conn = Faraday.new(:url => host) do |faraday|
      faraday.request :multipart
      faraday.adapter :net_http
    end
    conn.headers[:token] = '3c59dc048e8850243be8079a5c74d079'
    payload = {name: '健身課程', type: 1, during: 60, style: '1v1', price: 500, exp: 6, proposal: 8,
               intro: '这是一个测试课程', address: 2, customized: 0,
               '0' => Faraday::UploadIO.new('/root/images/1.jpg', 'image/jpeg'),
               '1' => Faraday::UploadIO.new('/root/images/2.jpg', 'image/jpeg'),
               '2' => Faraday::UploadIO.new('/root/images/3.jpg', 'image/jpeg')}
    response = conn.post '/business/courses', payload
    puts response.body
  end

  desc ''
  task :setting_one do
    conn = Faraday.new(:url => host)
    conn.headers[:token] = token
    response = conn.post '/business/settings/one', date: Date.today.next_day(3), address: 1, start: '9:00', end: '20:00', repeat: 1
    puts response.body
  end

  desc ''
  task :setting_many do
    conn = Faraday.new(:url => host)
    conn.headers[:token] = token
    response = conn.post '/business/settings/many', name: '健身課程', type: 1, date: Date.today.next_day(3), address: 1, start: '10:00', end: '12:00', place: 50
    puts response.body
  end

  desc ''
  task :appointment do
    conn = Faraday.new(:url => host)
    conn.headers[:token] = '3c59dc048e8850243be8079a5c74d079'
    response = conn.get '/business/appointments'
    puts response.body
  end


  desc ''
  task :appointment_create do
    conn = Faraday.new(:url => 'http://192.168.0.126')
    conn.headers[:token] = token
    response = conn.post '/business/appointments', course: 1, date: Date.today, start: '13:00', classes: 2, address: 1, online: '10053'
    puts response.body
  end
end