namespace :mine do
  host = 'http://stage.e-mxing.com'
  token = '182be0c5cdcd5072bb1864cdee4d3d6e'

  desc ''
  task :order do
    conn = Faraday.new(:url => host)
    conn.headers[:token] = token
    response = conn.get 'mine/orders/show', no: 143712273333850
    puts response.body
  end
end