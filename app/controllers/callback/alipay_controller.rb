module Callback
  class AlipayController < BaseController
    def callback

      render text: 'success'
    end
  end
end
