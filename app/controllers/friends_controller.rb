class FriendsController < ApiController
  def index
    begin
      ids = params[:mxids].split(',').collect { |mxid| mxid.to_i - 10000 }
      render json: Success.new(profiles: Profile.where(id: ids).collect { |profile| profile.as_json })
    rescue Exception => exp
      render json: Failure.new(exp.message)
    end
  end


  def create
    service = Service.find_by_mxid(params[:mxid])
    if service.nil?
      render json: Failure.new('服务号不存在')
    else
      add_friend_for_service(service)
      render json: Success.new
    end
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
    easemob_token = Rails.cache.fetch('easemob')
    result = Faraday.post do |req|
      req.url "#{MOB['host']}/users/#{service.profile.mxid}/contacts/users/#{@user.profile.mxid}"
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{easemob_token}"
    end
    logger.info result.body
  end

  def verify_auth_token
    @user = Rails.cache.fetch(request.headers[:token])
    render json: {code: -1, message: '用户未登录'} if @user.nil?
  end
end