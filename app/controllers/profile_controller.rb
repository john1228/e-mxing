class ProfileController < ApiController
  def index
    render json: {code: 1, data: {profile: @user.as_json}}
  end

  def complete
    mobile = Rails.cache.fetch(request.headers[:token])
    if mobile.nil?
      render json: {
                 code: 0,
                 message: '您到注册信息已过期,请重新注册'
             }
    else
      user = User.new(mobile: mobile, password: params[:password], device: params[:device], profile_attributes: {name: params[:name]})
      if user.save
        Rails.cache.write(user.token, user)
        render json: {code: 1, data: {user: user.summary_json}}
      else
        render json: {code: 0, message: '创建用户失败'}
      end
    end
  end

  def update
    profile = @user.profile
    if profile.update(profile_params)
      logger.info profile.as_json
      render json: Success.new(profile: profile)
    else
      render json: {code: 0, message: "修改失败:#{profile.errors.messages.values.join(';')}"}
    end
  end

  private
  def profile_params
    permit_params = params.permit(:name, :birthday, :avatar, :signature, :gender, :birthday, :address, :target, :skill, :often)
    permit_params.merge(hobby: params[:interests].split(','))
  end
end
