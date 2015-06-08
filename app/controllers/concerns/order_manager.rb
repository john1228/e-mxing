class OrderManager
  extend ActiveSupport::Concern

  def jd_pay
    host = 'https://m.jdpay.com/webpay/web/pay'
    version = '2.0' #版本号
    token = '' #交易令牌
    merchant_sign = '' #商户签名
    merchant_num = '' #商户号
    merchant_remark = '' #商户备注信息
    trade_num = '' #商户交易流水号
    trade_name = '' #订单标题
    trade_description= '' #订单描述
    trade_time = '' #订单时间,格式为 '%Y-%m-%d %H:%M:%S'
    trade_amount = '' #订单金额,单位为分
    currency='CNY' #币种
    success_callback_url = ''#支付成功跳转页面
    fail_callback_url = '' #支付失败时跳转页码
    notify_url = '' #支付完成后,异步通知支付结果
  end
end