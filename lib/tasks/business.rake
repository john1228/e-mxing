namespace :business do
  host = 'http://stage.e-mxing.com'
  token = '3c59dc048e8850243be8079a5c74d079'

  task :courses do
    conn = Faraday.new(:url => host)
    conn.headers[:token] = token
    response = conn.get '/business/courses'
    puts response.body
  end

end