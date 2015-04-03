namespace :find do
  desc '上傳定位'
  task :upload do
    host = 'http://localhost'
    conn = Faraday.new(:url => host)
    conn.headers['token'] = 'a87ff679a2f3e71d9181a67b7542122c'
    response = conn.post 'find', lng: '-121.0', lat: '70.0'
    puts response.body
  end

  desc '发现'
  task :index, [:type, :page, :lng, :lat] do |t, args|
    args.with_defaults(:type => 'dynamics', :page => 1, :lng => '-122.0', :lat => 70.0)
    host = 'http://localhost'
    conn = Faraday.new(:url => host)
    conn.headers['token'] = 'a87ff679a2f3e71d9181a67b7542122c'
    response = conn.get "find/#{args[:type]}", page: "#{args[:page]}", lng: "#{args[:lng]}", lat: "#{args[:lat]}"
    puts response.body
  end
end