module Business
  class AddressesController < BaseController
    def index
      render json: Success.new(addresses: @coach.addresses)
    end
  end
end