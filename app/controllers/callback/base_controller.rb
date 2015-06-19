module Callback
  class BaseController < ApplicationController
    before_action :logging
    private
    def logging
      controller_info = params[:controller].split('/')
    end
  end
end
