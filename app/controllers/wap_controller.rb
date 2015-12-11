class WapController < ApplicationController
  include AlipayManager
  layout 'wap'

  def index
    render layout: false
  end

  def film
    redirect_to controller: :share, action: :dynamic, id: params[:id]
  end

  def qrcode
    @qrcode = RQRCode::QRCode.new("http://github.com/", :size => 4, :level => :h)
    render layout: false
  end

  def alipay

  end

  def pay
    alipay_purchase(
        :out_trade_no => 1,
        :price => 1,
        :subject => '某某网',
        :body => '测试'
    )
  end
end
