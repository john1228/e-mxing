module Business
  class AddressesController < BaseController
    def index
      render json: Success.new(addresses: @coach.addresses)
    end

    def create
      address = @coach.addresses.new(address_params)
      if address.save
        render json: Success.new
      else
        render json: Failure.new('添加地址失败')
      end
    end

    private
    def address_params
      params.permit(:venues, :city, :address)
    end
  end
end