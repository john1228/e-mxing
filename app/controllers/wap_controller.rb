class WapController < ApplicationController
  include AlipayManager
  layout 'wap'

  def index
    render layout: false
  end

  def qrcode
    @qrcode = RQRCode::QRCode.new("http://github.com/", :size => 4, :level => :h)
    render layout: false
  end

  def alipay

  end

  def pay
    params = {
        :out_trade_no => '20121130000011',
        :subject => '测试订单',
        :total_fee => '0.1'
    }
    @url = trade_create_by_user_url(params)
    render layout: false
  end
end
