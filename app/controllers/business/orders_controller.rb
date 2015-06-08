module Business
  class OrdersController < BaseController
    def index
      render json: {code: 1, data: {orders: @coach.orders}}
    end
  end
end