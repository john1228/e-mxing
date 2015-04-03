namespace :tracks do
  desc '轨迹列表'
  task :index do
    host = 'http://localhost'
    conn = Faraday.new(:url => host)
    conn.headers[:token] = 'a87ff679a2f3e71d9181a67b7542122c'
    response = conn.get '/tracks', {mxid: 10002, page: 0}
    puts response.body
  end

  desc '发布轨迹'
  task :show do
    host = 'http://localhost'
    conn = Faraday.new(:url => host)
    conn.headers[:token] = 'a87ff679a2f3e71d9181a67b7542122c'
    response = conn.get '/tracks/show', id: 4
    puts response.body
  end


  desc '发布轨迹'
  task :create do
    host = 'http://localhost'
    conn = Faraday.new(:url => host)
    conn.headers[:token] = 'a87ff679a2f3e71d9181a67b7542122c'
    response = conn.post '/tracks', {type: 1, name: '跑步-100米', start: Time.now.strftime('%Y-%m-%d %H:%M'), during: '00:60:00'}
    puts response.body
  end

  desc '更新'
  task :update do
    host = 'http://localhost'
    conn = Faraday.new(:url => host)
    conn.headers[:token] = 'a87ff679a2f3e71d9181a67b7542122c'
    response = conn.put '/tracks', {id: 3, name: '跑步-1000米'}
    puts response.body
  end

  desc ' 删除课程 '
  task :delete do
    host = 'http://localhost'
    conn = Faraday.new(:url => host)
    conn.headers[:token] = 'a87ff679a2f3e71d9181a67b7542122c'
    response = conn.delete '/users/courses/1'
    puts response.body
  end

  desc ' 删除课程 '
  task :appoint do
    host = 'http://localhost'
    conn = Faraday.new(:url => host)
    conn.headers[:token] = 'a87ff679a2f3e71d9181a67b7542122c'
    response = conn.post '/tracks/appoint', id: 4
    puts response.body
  end

end