module Business
  module Schedules
    class HomeController < BaseController
      def index
        render json: Success.new(
                   schedule: @coach.schedules.where(date: params[:date]).map { |schedule|
                     schedule.as_json(
                         only: [:id, :start, :end, :user_name, :people_count],
                         include: {course: {only: [:course_name, :course_cover]}}
                     )
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
        set_off_ary = []
        if params[:batch].eql?('1')
          batch_start = Date.parse(params[:batch_start])
          batch_end = Date.parse(params[:batch_end])
          batch_days = params[:batch_days].split(',').map { |week_day| week_day.to_id }
          (batch_start..batch_end).each { |day|
            if batch_days.include?(day.wday)
              set_off_ary << {date: day, start: params[:start], end: params[:end]}
            end
          }
        end
        set_off_ary << {date: params[:date], start: params[:start], end: params[:end]}
        Schedule.create(set_off_ary)
        render json: Success.new
      end

      def destroy
        schedule = Schedule.find(params[:id])
        if schedule.destroy
          render json: Success.new
        else
          render json: Failure.new('删除失败:'+schedule.errors.messages.values.join(';'))
        end
      end

      private
      def schedule_params
        permit_params = params.permit(:date, :start, :end, :user_name, :mobile, :people_count)
        permit_params.merge(sku_id: params[:sku], coach_id: @coach.id)
      end
    end
  end
end