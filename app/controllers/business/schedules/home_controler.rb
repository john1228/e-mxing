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

      private
      def schedule_params
        params.permit(:sku, :date, :start, :end, :user_name, :mobile, :people_count)
      end
    end
  end
end