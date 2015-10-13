CarrierWave.configure do |config|
  config.storage = :file
  config.asset_host = 'http://stage.e-mxing.com'
  #config.asset_host = 'http://localhost'
end