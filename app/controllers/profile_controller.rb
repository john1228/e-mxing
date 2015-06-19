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
      user = User.new(mobile: @mobile, password: params[:password], name: params[:name])
      if user.save
        Rails.cache.write(user.token, user)
        render json: {code: 1, data: {user: user.summary_json}}
      else
        render json: {code: 0, message: '创建用户失败'}
      end
    end
  end

  def update
    if @user.profile.update(profile_params)
      render json: {code: 1}
    else
      render json: {code: 0, message: '修改失败'}
    end
  end

  private
  def profile_params
    params.permit(:name, :birthday, :avatar, :signature, :gender, :birthday, :address, :interests, :target, :skill, :often)
  end
end
