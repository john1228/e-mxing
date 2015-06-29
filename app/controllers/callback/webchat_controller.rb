module Callback
  class WebchatController < BaseController
    def callback
      params.map { |k, v|
        logger.info "#{k}<<<#{v}"
      }
      logger.info request.body
      render text: 'success'
    end

    def prepay

    end
  end
end
