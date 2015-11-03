module Callback
  class QiniuController < ApplicationController
    def callback
      params.each { |k, v| logger.info "同步参数: #{k}-#{v}" }
      render text: 'success'
    end
  end
end
