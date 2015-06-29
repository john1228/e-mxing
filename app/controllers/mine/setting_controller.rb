module Mine
  class SettingController < BaseController
    def update
      setting = Setting.find_or_create(user: @user)
      if setting.update(stealth: params[:stealth])
        render json: Success.new
      else
        render json: Failure.new(setting.errors.map { |k, v| "#{k}:#{v}" })
      end
    end
  end
end