module Callback
  class WebchatController < BaseController
    def callback
      request_data = Hash.from_xml(request.body.read)['xml'].symbolize_keys
      request_data.map { |k, v|
        logger.info "#{k}<<<#{v}"
      }
      render text: 'success'
    end

    def prepay

    end
  end
end
