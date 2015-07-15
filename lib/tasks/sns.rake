namespace :sns do
  desc '计算周like榜'
  task :qq => :environment do
    conn = Faraday.new(url: 'http://stage.e-mxing.com')
    response = conn.post '/login/sns', sns: 'qq', code: '38308E7AE37FF416351D0CA464DC80B3'
    puts response.body
  end
end