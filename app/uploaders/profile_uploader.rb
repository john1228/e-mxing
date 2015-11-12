# encoding: utf-8

class ProfileUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :qiniu
  process :resize_to_limit => [1024, 1024]

  def store_dir
    "images/#{model.class.to_s.underscore}"
  end
end
