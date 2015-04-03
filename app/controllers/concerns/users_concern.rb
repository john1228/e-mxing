module UsersConcern
  extend ActiveSupport::Concern

  included do
    before_action :check_user, only: [:update, :delete, :bind]
    before_action :verify_password, only: :login
    before_action :verify_sns, only: :sns
  end

  def check_user
    @user = Rails.cache.read(request.headers[:token])
    if @user.nil?
      render json: {
                 code: 0,
                 message: ['您还未登录！']
             }
    end
  end

  def verify_password
    user = User.find_by(username: params[:username])
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
                   message: '您输入到密码不正确'
               }
      end
    end
  end

  def verify_sns
    @user = User.find_or_create_by(username: "#{params[:sns_name]}_#{params[:sns_id]}")
    if @user.profile.nil?
      regist_single(@user.id, @user.password, params[:name]||'')
      if params[:sns_name].eql?('weixin')
        icon_array = params[:icon].split('/')
        icon_array.last
      end
      @user.create_profile(name: params[:name], gender: params[:gender], remote_avatar_url: params[:avatar], birthday: params[:birthday])
    end
    Rails.cache.write(@user.token, @user)
  end
end