# encoding: utf-8

class ActivityCoverUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :file

  def store_dir
    "images/#{model.class.to_s.underscore}"
  end

  version :large do
    process :resize_to_fit => [2208, 2208]
  end

  version :thumb do
    process :resize_to_fit => [150, 210]
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
