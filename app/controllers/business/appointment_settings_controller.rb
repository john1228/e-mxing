module Business
  class AppointmentSettingsController<BaseController
    #1v1课程设置
    def one_to_one
      logger.info one_params
      setting = @coach.appointment_settings.new(one_params)
      if setting.save
        render json: {code: 1}
      else
        render json: {code: 0, message: '设置失败'}
      end
    end

    #团操课程设置
    def one_to_many
      setting = @coach.appointment_settings.new(many_params)
      if setting.save
        render json: {code: 1}
      else
        render json: {code: 0, message: '设置失败'}
      end
    end

    private
    def one_params
      {
          start_date: params[:date],
          start_time: params[:start],
          end_time: params[:end],
          repeat: params[:repeat],
          address_id: @coach.addresses.find_by(id: params[:address]).id
      }
    end

    def many_params
      {
          course_name: params[:name],
          course_type: params[:type],
          start_date: params[:date],
          start_time: params[:start],
          end_time: params[:end],
          place: params[:place],
          address_id: @coach.addresses.find_by(id: params[:address]).id
      }
    end
  end
end