namespace :mine do
  host = 'http://stage.e-mxing.com'
  token = '6ea9ab1baa0efb9e19094440c317e21b'

  desc '未完成课时'
  task :lesson_incomplete do
    conn = Faraday.new(:url => host)
    conn.headers[:token] = token
    response = conn.get 'mine/classes/incomplete'
    puts response.body
  end

  desc '未完成课时详情'
  task :lesson_incomplete do
    conn = Faraday.new(:url => host)
    conn.headers[:token] = token
    response = conn.get 'mine/classes/incomplete?id='
    puts response.body
  end

  desc '已完成课时'
  task :lesson_incomplete do
    conn = Faraday.new(:url => host)
    conn.headers[:token] = token
    response = conn.get 'mine/classes/complete'
    puts response.body
  end
end