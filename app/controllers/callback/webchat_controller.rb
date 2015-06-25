module Callback
  class WebchatController < BaseController
    def callback
      params.map { |k, v|
        logger.info "#{k}<<<#{v}"
      }
      render text: 'success'
    end

    def prepay

    end
  end
end
