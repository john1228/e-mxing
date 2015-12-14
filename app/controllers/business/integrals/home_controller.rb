module Business
  module Integrals
    class HomeController < BaseController
      def show
        render json: Success.new(integral: @coach.wallet.integral)
      end

      def detail
        render json: Success.new(detail: @coach.wallet.wallet_logs.where('integral <> 0').order(created_at: :desc).page(params[:page]||1).map { |log|
                                   {
                                       source: log.source,
                                       integral: log.integral,
                                       created: log.created_at.localtime.strftime('%Y-%m-%d')
                                   }
                                 })
      end
    end
  end
end