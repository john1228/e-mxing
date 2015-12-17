module Business
  module Schedules
    class HomeController < BaseController
      def index
        render json: Success.new(
                   schedule: @coach.schedules.where(date: params[:date]).order(start: :asc).map { |schedule|
                     schedule.as_json(
                         only: [:id, :start, :end, :people_count, :user_name, :remark],
                         include: {course: {only: :id, methods: [:name, :cover, :during]}}
                     )
                   }
               )
      end

      def create
        case params[:type]
          when 'mine'
            logger "====#{member_params.to_json}"
            schedule = Schedule.member.new(member_params)
            if schedule.save
              render json: Success.new
            else
              render json: Failure.new(schedule.errors.messages.values.join(';'))
            end
          when 'student'
            logger "====#{platform_params.to_json}"
            schedule = Schedule.platform.new(platform_params)
            if schedule.save
              render json: Success.new
            else
              render json: Failure.new(schedule.errors.messages.values.join(';'))
            end
          when 'off'
            set_off_ary = []
            if params[:batch].eql?('1')
              batch_start = Date.parse(params[:batch_start])
              batch_end = Date.parse(params[:batch_end])
              batch_days = params[:batch_days].split(',').map { |week_day| week_day.to_i }
              (batch_start..batch_end).each { |day|
                if batch_days.include?(day.wday)
                  set_off_ary << {date: day, start: params[:start], end: params[:end], coach_id: @coach.id}
                end
              }
            end
            set_off_ary << {date: params[:date], start: params[:start], end: params[:end], coach_id: @coach.id}
            Schedule.create(set_off_ary)
            render json: Success.new
          else
            render Failure.new('无效的请求')
        end
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
      def platform_params
        permit_params = params.permit(:date, :start, :people_count)
        sku = Sku.find(params[:sku])
        user = User.find_by_mxid(params[:mxid])
        permit_params.merge(
            sku_id: params[:sku],
            coach_id: @coach.id,
            end: (Time.parse(params[:start], Date.parse(params[:date]) + sku.course_during)).strftime('%H:%M'),
            user_id: user.id,
            user_name: user.profile.name
        )

      end

      def member_params
        permit_params = params.permit(:date, :start, :people_count)
        sku = Sku.find(params[:sku])
        member = Member.find(params[:id])
        permit_params.merge(
            sku_id: params[:sku],
            coach_id: @coach.id,
            end: (Time.parse(params[:start], Date.parse(params[:date]) + sku.course_during)).strftime('%H:%M'),
            user_id: member.id,
            user_name: member.name
        )
      end
    end
  end
end