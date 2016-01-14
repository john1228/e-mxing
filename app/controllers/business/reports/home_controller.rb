module Business
  module Reports
    class HomeController < BaseController
      def index
        @token = params[:token]
        render layout: 'report'
      end

      def report
        today = Date.today
        coach_orders = Order.pay.where(seller_id: @coach.id)
        case params[:type]
          when 'daily'
            orders = coach_orders.where(updated_at: today..today.tomorrow)
            title = '七日销售情况'
            categories = (0..6).map { |index|
              today.prev_day(index)
            }.reverse
            data = categories.map { |item|
              coach_orders.where(updated_at: item..item.tomorrow).sum(:total).floor
            }
          when 'weekly'
            orders = coach_orders.where(updated_at: today.prev_week..today.tomorrow)
            title = '本周销售情况'
            categories =(today.at_beginning_of_week..today).map { |item|
              item
            }
            data = categories.map { |item|
              coach_orders.where(updated_at: item..item.tomorrow).sum(:total).floor
            }
          when 'monthly'
            orders = coach_orders.where(updated_at: today.at_beginning_of_month..today.tomorrow)
            title = '本月銷售情況'
            categories = (0..today.cweek).map { |item| "第#{item+1}周" }
            data = (0..today.cweek).map { |item|
              date = today.weeks_ago(item)
              if date.month.eql?(today.month)
                start_date = date.at_beginning_of_week
                end_date = date.at_end_of_week.tomorrow
              else
                start_date = today.at_beginning_of_month
                end_date = date.at_end_of_week.tomorrow
              end
              logger.info "#{start_date}--#{end_date}"
              coach_orders.where(updated_at: start_date..end_date).sum(:total).floor
            }.reverse
          else
            orders = coach_orders.where(updated_at: today..today.tomorrow)
            title = '七日销售情况'
            categories = (0..6).map { |index|
              today.prev_day(index)
            }.reverse
            data = categories.map { |item|
              coach_orders.where(updated_at: item..item.tomorrow)
            }
        end

        render json: {
                   sale: orders.sum(:total).floor,
                   platform: orders.platform.sum(:total).floor,
                   face_to_face: orders.face_to_face.sum(:total).floor,
                   order: orders.count,
                   appointment: appointments.count,
                   report: {
                       categories: categories,
                       title: title,
                       data: data
                   }
               }
      end
    end
  end
end