class UsersController < ApiController

  def login
    login_user = User.find_by(mobile: params[:username])
    if login_user.nil?
      render json: Failure.new('该用户还未注册')
    else
      login_user.update(device: params[:device]) if login_user.blank?
      render json: {code: 0, message: '该用户已经被用户举报封存，如有疑问，可联系客服人员咨询解封'} if Blacklist.find_by(user: login_user).present?
      my_password = Digest::MD5.hexdigest("#{params[:password]}|#{login_user.salt}")
      if login_user.password.eql?(my_password)
        Rails.cache.write(login_user.token, login_user)
        render json: Success.new(user: login_user.summary_json)
      else
        render json: Failure.new('您输入的密码不正确')
      end
    end

  end

  def sns
    login_user = User.find_by(sns: "#{params[:sns_name]}_#{params[:sns_id]}")
    if login_user.nil?
      if params[:sns_name].eql?('weixin')
        avatar_array = params[:avatar].split('/')
        avatar_array.last
      end
      login_user = User.create(sns: "#{params[:sns_name]}_#{params[:sns_id]}", name: params[:name],
                               avatar: params[:avatar], gender: params[:gender], birthday: params[:birthday])
    end
    login_user.update(device: params[:device]) if login_user.blank?
    render json: {code: 0, message: '该用户已经被用户举报封存，如有疑问，可联系客服人员咨询解封'} if Blacklist.find_by(user: login_user).present?
    Rails.cache.write(login_user.token, login_user)
    render json: Success.new(user: login_user.summary_json)
  end


  def update
    if params[:password].present?
      if @user.password.eql?(Digest::MD5.hexdigest("#{params[:password]}|#{@user.salt}"))
        if @user.update(password: params[:new_password])
          Rails.cache.write(@user.token, @user.reload)
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
end
