namespace :rank do
  desc '测试更新'
  task :week => :environment do
    start_date = Date.today.at_beginning_of_week
    end_date = Date.today.yesterday
    ranks = Like.where(like_type: Like::PERSON, created_at: start_date..end_date).group(:liked_id).limit(50).order('count_id desc').count(:id)
    Rails.cache.write('week', ranks)
  end

  desc '测试更新'
  task :update => :environment do
    host = 'http://localhost'
    conn = Faraday.new(:url => host)
    conn.headers['token'] = 'a87ff679a2f3e71d9181a67b7542122c'
    response = conn.put '/profile', {signature: "测试更新"}
    puts response.body
  end
end