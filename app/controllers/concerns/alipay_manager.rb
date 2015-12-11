module AlipayManager
  extend ActiveSupport::Concern

  def alipay_purchase(options={})
    # 准备请求参数
    query = prepare_params(options)
    # 阿里网关url + 请求参数
    alipay_url = 'https://mapi.alipay.com/gateway.do?' + hash_to_url(query)
    # 页面跳转
    redirect_to alipay_url
  end

  private
  def prepare_params(options={})
    partner = '2088712149046512'
    secret = 'MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCsJpQ3AUoK7q2/AVNWdHXlqDkwFKf1feC2NG2Bn6QX1ylIO+qEajZOYDLyivOvVxrgf5iAfWuR2c3R2qhKysoDWU5T1wbJnfkgcQnm+jenI3Ph14EDNb7kuBRVk6uvdl+Sqj5MmYSi7GyvynL3Vi2Jy7tzSo3GYY1BGheD/Ew88QIDAQAB'
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
    query_params[:sign] = Digest::MD5.hexdigest(hash_to_url(query_params) + secret)
    query_params[:sign_type] = 'MD5'
    query_params
  end

  def hash_to_params(hash)
    str = hash.map { |key, value| "#{key}=#{value.to_s}" }.join("&")
  end

  def hash_to_url(hash)
    str = hash.map { |key, value| "#{key}=#{CGI.escape(value.to_s)}" }.join("&")
  end

end
