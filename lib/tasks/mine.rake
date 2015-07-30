namespace :mine do
  host = 'http://stage.e-mxing.com'
  token = '6ea9ab1baa0efb9e19094440c317e21b'

  desc ''
  task :lesson do
    conn = Faraday.new(:url => host)
    conn.headers[:token] = token
    response = conn.get 'mine/classes/incomplete'
    puts response.body
  end
end