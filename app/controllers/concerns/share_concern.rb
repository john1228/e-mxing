module ShareConcern
  extend ActiveSupport::Concern

  def share(sns)
    case sns
      when 'sina'
        faraday = Faraday.new(url: 'http://api.t.sina.com.cn)')
        response = faraday.post '/users/show.json', access_token: '2.004Da7PBulid8D87cb6a9bb8iYjHgD', screen_name: 'fighting'
        logger.info "分享微博结果:#{response.body}"
      when 'qzone'
        faraday = Faraday.new(url: 'http://api.t.sina.com.cn)')
        response = faraday.post '/statuses/update.json'
        logger.info "分享微博结果:#{response.body}"
      else
    end
  end
end