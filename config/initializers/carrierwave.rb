::CarrierWave.configure do |config|
  config.storage = :qiniu
  config.qiniu_access_key = "51PeOMLBoxi1VFBrZgT8vTe-mW64g19DbEtPUCem"
  config.qiniu_secret_key = 'IlQDXWZROSw8shqT42s5nw4Bp2ol-BmyOsjd21g9'
  config.qiniu_bucket = "emxing"
  config.qiniu_bucket_domain = "7xl2f5.com1.z0.glb.clouddn.com"
  config.qiniu_block_size = 4*1024*1024
end

