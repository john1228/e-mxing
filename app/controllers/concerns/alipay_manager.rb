module AlipayManager
  extend ActiveSupport::Concern
  URL = 'https://mapi.alipay.com/gateway.do'
  FACE_TO_FACE_URL = ''
  PARTNER_ID = '2088712149046512'
  PARTNER_EMAIL = 'jianglei@e-mxing.com'
  PAYMENT_TYPE = '1'
  SIGN_TYPE = 'MD5'
  INPUT_CHARSET = 'utf-8'
  SERVICE = 'create_direct_pay_by_user'
  PUBLIC_KEY = 'tf8rgraz2e5klukgllm39cxdmdsjr9jm'
  PRIVATE_KEY = 'MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAKwmlDcBSgrurb8BU1Z0deWoOTAUp/V94LY0bYGfpBfXKUg76oRqNk5gMvKK869XGuB/mIB9a5HZzdHaqErKygNZTlPXBsmd+SBxCeb6N6cjc+HXgQM1vuS4FFWTq692X5KqPkyZhKLsbK/KcvdWLYnLu3NKjcZhjUEaF4P8TDzxAgMBAAECgYAMgjkezg8tQC6LxHLjw06Vw2V0YuvZYK4lTyXt10W7Hb04LHJb8MPFaiQJj6MpSHEBgwP3wiVA0cysxPCZjqai/RJQIAYwyvuq4NrANVczEkikRZtWJOSyB1yN4TRIz1d2WuF2bpr+UBQnYlgQ2ap373rzDjKtbCe9Y+l26LdPyQJBAOFzvRzadQb1W/Fh2CSUYvC2CBi74mjHSnT/jMOkTMuwZS+E9FWZrla+hTojdDIpPI5Bjm9UOEATNZMyGrzHxWsCQQDDefkyCeF7kqqPDSzTu/kttCTjBkweNJ+HAEoP4riX9ifeubRMAzSAC047nbiXa4pQIv2hnA/cLDn+TXG7eUITAkAExJfZRl13OjUpk7Iog+LbyF2/eCm/oYdXlhf6Az2EiUR6jstEDC39s6XJpvpMHUckkwpaHGPcJwvZAxRBrc/lAkBSWuIlNcp8wIcBK+DV99z8Z2gfCbkqBKutOe76EGALDdcwW/bdC4Cj7Z9xOHrbuKAWMRfAbbq03SE1xbUD8gtnAkBx/JK2pHyKQv8IG0CagEe5D/3COD09yoM4VYTDVU1letXn6ViNay9tWvUPdLaJM52pX8eBEr/taUo2mfm0Lelx'
  PAY_MODE = 1
  NOTIFY_URL = 'http://www.e-mxing.com/callback/alipay'
  RETURN_URL = 'http://www.e-mxing.com/business/face_to_faces/paid'


  def trade_create_by_user_url(params={})
    alipay_params = {
        service: SERVICE,
        _input_charset: INPUT_CHARSET,
        partner: PARTNER_ID,
        seller_email: PARTNER_EMAIL,
        payment_type: PAYMENT_TYPE,
        qr_pay_mode: PAY_MODE,
        notify_url: NOTIFY_URL,
        return_url: RETURN_URL
    }.merge(params)
    uri = URI(URL)
    uri.query = URI.encode_www_form(alipay_params.merge(sign_type: SIGN_TYPE, sign: sign(alipay_params)))
    uri.to_s
  end

  def face_to_face_url(params={})
    alipay_params = {
        appid: PARTNER_ID,
        charset: INPUT_CHARSET,
        timestamp: Time.now.strftime('%Y-%m-%d %H:%M:%S'),
        biz_content: params
    }
  end

  private
  def sign(params={})
    params = stringify_keys(params)
    sign_type = SIGN_TYPE
    key = PUBLIC_KEY
    string = params_to_string(params)
    case sign_type
      when 'MD5'
        md5_sign(string, key)
      when 'RSA'
        rsa_sign(string, key)
      when 'DSA'
        dsa_sign(string, key)
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
