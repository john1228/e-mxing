class UsersController < ApplicationController
  include UsersConcern
  include Easemob

  def login
    render json: {
               code: 1,
               data: {user: @user.summary_json}
           }
  end

  def sns
    render json: {
               code: 1,
               data: {user: @user.summary_json}
           }
  end


  def update
    if params[:password].present?
      if @user.password.eql?(Digest::MD5.hexdigest("#{password}--#{@user.salt}"))
        @user.update(password: params[:new_password])
      else
        render json: {
                   code: 0,
                   message: '您输入到原密码错误'
               }
      end
    else
      @user.update(password: params[:new_password])
    end
    render json: {
               code: 1,
               message: "success"
           }
  end

  def feedback
    render json: {
               code: 1,
               message: 'success'
           }
  end

  def logout
    if Rails.cache.delete(@user.token)
      render json: {
                 code: 1,
                 message: 'success'
             }
    else
      render json: {
                 code: 0,
                 message: 'success'
             }
    end
  end

  def bind
  end

  private
  def user_params
    params.permit(:name, :password)
  end
end
