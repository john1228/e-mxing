namespace :business do
  #host = 'http://stage.e-mxing.com'
  host = 'http://localhost'
  token = '02e74f10e0327ad868d138f2b4fdd6f0'

  task :login do
    conn = Faraday.new(:url => host)
    response = conn.post '/business/login', {mobile: '13916518973', password: '123456'}
    puts response.body
  end

  task :courses do
    conn = Faraday.new(:url => host)
    conn.headers[:token] = token
    response = conn.get '/business/courses'
    puts response.body
  end

  task :face_to_faces do
    conn = Faraday.new(:url => host)
    conn.headers[:token] = token
    response = conn.get '/business/face_to_faces'
    puts response.body
  end

  task :integrals do
    conn = Faraday.new(:url => host)
    conn.headers[:token] = token
    response = conn.get '/business/integrals'
    puts response.body
  end

  task :integrals_details do
    conn = Faraday.new(:url => host)
    conn.headers[:token] = token
    response = conn.get '/business/integrals/detail'
    puts response.body
  end

  task :schedules do
    conn = Faraday.new(:url => host)
    conn.headers[:token] = token
    response = conn.get '/business/schedules'
    puts response.body
  end

  task :students do
    conn = Faraday.new(:url => host)
    conn.headers[:token] = token
    response = conn.get '/business/students'
    puts response.body
  end

  task :students_member do
    conn = Faraday.new(:url => host)
    conn.headers[:token] = token
    response = conn.get '/business/students/member'
    puts response.body
  end

  task :students_mxing do
    conn = Faraday.new(:url => host)
    conn.headers[:token] = token
    response = conn.get '/business/students/mxing'
    puts response.body
  end


end