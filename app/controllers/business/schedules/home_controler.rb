module Business
  module Schedules
    class HomeController < BaseController
      def index
        render json: Success.new(
                   schedule: @coach.schedules.where(date: params[:date]).map { |schedule|
                     schedule.as_json(only: [:start, :end, :user_name, :people_count], include: {course: {only: [:course_name, :course_cover]}})
                   }
               )
      end

      def create
        schedule = Schedule.new(schedule_params)
        if schedule.save
          render json: Success.new
        else
          render json: Failure.new(schedule.errors.messages.join(';'))
        end
      end

      def set_off
        set_off_setting = @coach.set_offs.new(schedule_params)
        if set_off_setting.save
          render json: Success.new
        else
          render json: Failure.new('设置失败:' + set_off_setting.errors.messages.join(';'))
        end
      end

      private
      def schedule_params
        permit_params = params.permit(:date, :start, :end, :user_name, :mobile, :people_count)
        permit_params.merge(sku_id: params[:sku], coach_id: @coach.id)
      end

      def set_off_setting_params
        permit_params = params.permit(:start, :end, :repeat)
        permit_params.merge(week: params[:days].split(','))
      end
    end
  end
end