module Alipay
  module Getaway
    def alipay_purchase(options={})
      # 准备请求参数
      query = prep_params(options)
      # 阿里网关url + 请求参数
      alipay_url = 'https://mapi.alipay.com/gateway.do?' + hash_to_url(query)
      # 页面跳转
      redirect_to alipay_url
    end

    private
    def prep_params(options={})
      partner = ''
      secret = ''
      query_params = {
          partner: partner,
          _input_charset: 'utf-8',
          service: 'trade_create_by_buyer',
          out_trade_no: options[:out_trade_no],
          price: options[:price],
          quantity: 1,
          seller_id: partner,
          payment_type: 1,
          subject: options[:subject],
          body: options[:body]
      }
      query_params = query_params.sort.to_h
      query_params[:sign] = Digest::MD5.hexdigest(hash_to_params(query_params) + secret)
      query_params[:sign_type] = 'MD5'
      query_params
    end

    def hash_to_params(hash)
      hash.map { |key, value| "#{key}=#{value.to_s}" }.join("&")
    end

    def hash_to_url(hash)
      hash.map { |key, value| "#{key}=#{CGI.escape(value.to_s)}" }.join("&")
    end
  end
end