module Business
  class OrdersController < BaseController
    def index
      render json: Success.new({orsers: @coach.orders})
    end
  end
end