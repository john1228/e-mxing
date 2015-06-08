module Business
  class AddressesController < BaseController
    def index
      render json: {
                 code: 1,
                 data: {
                     addresses: @coach.addresses.collect { |address| address.as_json }
                 }
             }
    end

    def create
      address = @coach.addresses.new(address_params)
      if address.save
        render json: {code: 1}
      else
        render json: {code: 0, message: '添加地址失败'}
      end
    end

    private
    def address_params
      params.permit(:venues, :city, :address)
    end
  end
end