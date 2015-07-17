# encoding: utf-8

class PhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :file
  process :resize_to_limit => [2080, nil]

  def store_dir
    'images/photo'
  end

  version :thumb do
    process :resize_to_fit => [300, nil]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
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
