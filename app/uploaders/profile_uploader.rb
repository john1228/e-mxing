# encoding: utf-8

class ProfileUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  storage :file

  def store_dir
    "images/#{model.class.to_s.underscore}"
  end

  def default_url
    "/images/default/user.jpg"
  end

  version :thumb do
    process :resize_to_fit => [140, 140]
  end

  def filename
    "#{Time.now.strftime('%Y/%m/%d')}/#{secure_token}.#{file.extension}" if original_filename
  end

  protected
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end
end
