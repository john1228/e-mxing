module AlipayManager
  extend ActiveSupport::Concern
  URL = 'https://mapi.alipay.com/gateway.do'
  MOBILE_REQUIRED_PARAMS = %w( notify_url out_trade_no subject total_fee body )
  PARTNER_ID = '2088712149046512'
  PARTNER_EMAIL = 'jianglei@e-mxing.com'
  PAYMENT_TYPE = '1'
  SIGN_TYPE = 'MD5'
  INPUT_CHARSET = 'utf-8'
  SERVICE = 'create_partner_trade_by_buyer'
  SECRET = 'MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCsJpQ3AUoK7q2/AVNWdHXlqDkwFKf1feC2NG2Bn6QX1ylIO+qEajZOYDLyivOvVxrgf5iAfWuR2c3R2qhKysoDWU5T1wbJnfkgcQnm+jenI3Ph14EDNb7kuBRVk6uvdl+Sqj5MmYSi7GyvynL3Vi2Jy7tzSo3GYY1BGheD/Ew88QIDAQAB'

  def trade_create_by_user_url(params={})
    alipay_params = {
        service: SERVICE,
        _input_charset: INPUT_CHARSET,
        partner: PARTNER_ID,
        seller_email: PARTNER_EMAIL,
        payment_type: PAYMENT_TYPE
    }.merge(params)
    uri = URI(URL)
    uri.query = URI.encode_www_form(alipay_params.merge(sign_type: SIGN_TYPE, sign: sign(alipay_params)))
    uri.to_s
  end

  private
  def sign(params={})
    params = stringify_keys(params)
    sign_type = SIGN_TYPE
    secret = SECRET
    string = params_to_string(params)
    logger.info "<<<<#{string}"
    case sign_type
      when 'MD5'
        md5_sign(string, secret)
      when 'RSA'
        rsa_sign(string, secret)
      when 'DSA'
        dsa_sign(string, secret)
      else
        raise ArgumentError, "invalid sign_type #{sign_type}, allow value: 'MD5', 'RSA', 'DSA'"
    end
  end

  def params_to_string(params)
    params.sort.map { |item| item.join('=') }.join('&')
  end

  def md5_sign(string, key)
    Digest::MD5.hexdigest("#{string}#{key}")
  end

  def rsa_sign(string, key)
    raise NotImplementedError, 'RSA sign is not implemented'
  end

  def dsa_sign(string, key)
    raise NotImplementedError, 'DSA sign is not implemented'
  end

  def stringify_keys(hash)
    new_hash = {}
    hash.each do |key, value|
      new_hash[(key.to_s rescue key) || key] = value
    end
    new_hash
  end
end
