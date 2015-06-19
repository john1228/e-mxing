class FriendsController < ApplicationController
  def index
    ids = params[:mxids].split(',').collect { |mxid| mxid.to_i - 10000 }
    render json: {
               code: 1,
               data: {profiles: Profile.where(id: ids).collect { |profile| profile.as_json }}
           }
  end


  def create
    service = Service.find_by_mxid(params[:mxid])
    if service.nil?
      render json: {code: 0, message: '服务号不存在'}
    else
      add_friend_for_service(service)
      render json: {code: 1}
    end
    service = Service.first
    add_friend_for_service(service)
    render json: {code: 1}
  end

  def find
    case params[:type]
      when 'person'
        result = User.joins(:profile).where('profiles.name  ~* ? or profiles.id=?', params[:keyword], (params[:keyword].to_i-Profile::BASE_NO))
      when 'service'
        result = Service.joins(:profile).where('profiles.name  ~* ? or profiles.id=?', params[:keyword], (params[:keyword].to_i-Profile::BASE_NO))
      when 'group'
        result = Group.where('groups.name  ~* ? or groups.id = ?', params[:keyword], params[:keyword].to_i)
      else
        result = []
    end
    render json: {
               code: 1,
               data: {
                   "#{params[:type]}s" => result.collect { |item| item.summary_json }
               }
           }
  end

  private
  def add_friend_for_service(service)
    easemob_token = Rails.cache.fetch('easemob')||init_easemob_token
    result = Faraday.post do |req|
      req.url "https://a1.easemob.com/jsnetwork/mxing/users/#{service.profile_mxid}/contacts/users/#{@user.profile_mxid}"
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{easemob_token}"
    end
    logger.info result.body
  end

  def verify_auth_token
    @user = Rails.cache.fetch(request.headers[:token])
    render json: {code: -1, message: '用户未登录'} if @user.nil?
  end

  def init_easemob_token
    token_response = Faraday.post do |req|
      req.url 'https://a1.easemob.com/jsnetwork/mxing/token'
      req.headers['Content-Type'] = 'application/json'
      req.body = "{\"grant_type\": \"client_credentials\", \"client_id\": \"YXA6HPZzIHIkEeSy6P9lvafoPA\", \"client_secret\": \"YXA6GQOgkrCoDL61TY9IPzRcto4mJn4\"}"
    end
    easemob_body = JSON.parse(token_response.body)
    Rails.cache.write('easemob', easemob_body['access_token'], expires_in: easemob_body['expires_in'])
    easemob_body['access_token']
  end
end