class UsersController < ApiController
  before_action :verify_password, only: :login
  before_action :verify_password, only: :sns

  def login
    render json: Success.new(user: @user.summary_json)
  end

  def sns
    render json: Success.new(user: @user.summary_json)
  end


  def update
    if params[:password].present?
      if @user.password.eql?(Digest::MD5.hexdigest("#{params[:password]}|#{@user.salt}"))
        if @user.update(password: params[:new_password])
          render json: {code: 1}
        else
          render json: {code: 0, message: '更新密码失败'}
        end
      else
        render json: {code: 0, message: '您输入到原密码错误'}
      end
    else
      render json: {code: 0, message: '请输入原密码'}
    end
  end

  def feedback
    render json: {code: 1, message: 'success'}
  end

  def logout
    if Rails.cache.delete(@user.token)
      render json: {code: 1, message: 'success'}
    else
      render json: {code: 0, message: 'success'}
    end
  end

  def bind
  end

  private
  def user_params
    params.permit(:name, :password)
  end

  def verify_password
    @user = User.find_by(mobile: params[:username])
    if @user.nil?
      render json: Failure.new('该用户还未注册')
    else
      my_password = Digest::MD5.hexdigest("#{params[:password]}|#{@user.salt}")
      if @user.password.eql?(my_password)
        logger.info '登录成功'
        Rails.cache.write(@user.token, @user)
      else
        render json: Failure.new('您输入的密码不正确')
      end
    end
  end

  def verify_sns
    @user = User.find_by(sns: "#{params[:sns_name]}_#{params[:sns_id]}")
    if @user.nil?
      if params[:sns_name].eql?('weixin')
        avatar_array = params[:avatar].split('/')
        avatar_array.last
      end
      @user = User.create(sns: "#{params[:sns_name]}_#{params[:sns_id]}", name: params[:name],
                          avatar: params[:avatar], gender: params[:gender], birthday: params[:birthday])
    end
    Rails.cache.write(@user.token, @user)
  end
end
