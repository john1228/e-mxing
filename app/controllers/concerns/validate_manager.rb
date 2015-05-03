module ValidateManager
  extend ActiveSupport::Concern

  included do
    before_action :verify_password, only: :login
    before_action :verify_sns, only: :sns
  end

  def check_user
    @user = Rails.cache.read(request.headers[:token])
    if @user.nil?
      render json: {
                 code: 0,
                 message: '您还未登录'
             }
    end
  end

  def verify_password
    user = User.find_by(mobile: params[:username])
    if user.nil?
      render json: {
                 code: 0,
                 message: '该用户还未注册'
             }
    else
      my_password = Digest::MD5.hexdigest("#{params[:password]}|#{user.salt}")
      if user.password.eql?(my_password)
        Rails.cache.write(user.token, user)
        @user = user
      else
        render json: {
                   code: 0,
                   message: '您输入的密码不正确'
               }
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
      @user = User.create(
          sns: "#{params[:sns_name]}_#{params[:sns_id]}",
          name: params[:name],
          avatar: params[:avatar],
          gender: params[:gender],
          birthday: params[:birthday]
      )
    end
    Rails.cache.write(@user.token, @user)
  end
end