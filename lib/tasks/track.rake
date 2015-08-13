namespace :tracks do
  desc '轨迹列表'
  task :index do
    host = 'http://stage.e-mxing.com'
    conn = Faraday.new(:url => host)
    conn.headers[:token] = '2a38a4a9316c49e5a833517c45d31070'
    response = conn.get '/shop/courses', sku: 'CC-000139-000056'
    puts response.body
  end
end