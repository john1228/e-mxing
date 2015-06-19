module Callback
  class BaseController < ApplicationController
    before_action :logging
    private
    def logging
      logger.info params[:controller]
    end
  end
end
