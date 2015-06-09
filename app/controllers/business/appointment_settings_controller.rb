module Business
  class AppointmentSettingsController<BaseController
    #1v1课程设置
    def one_to_one
      setting = @coach.appointment_settings.new(one_params)
      if setting.save
        render json: Success.new({})
      else
        render json: Failure.new('设置失败')
      end
    end

    #团操课程设置
    def one_to_many
      setting = @coach.appointment_settings.new(many_params)
      if setting.save
        render json: Success.new({})
      else
        render json: Failure.new('设置失败')
      end
    end

    private
    def one_params
      {
          start_date: params[:date],
          time: params[:time],
          repeat: params[:repeat],
          address_id: @coach.addresses.find_by(id: params[:address]).id
      }
    end

    def many_params
      {
          course_name: params[:name],
          course_type: params[:type],
          start_date: params[:date],
          time: "#{params[:start]}|#{params[:end]}",
          place: params[:place],
          address_id: @coach.addresses.find_by(id: params[:address]).id
      }
    end
  end
end