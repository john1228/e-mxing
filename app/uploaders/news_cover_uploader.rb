# encoding: utf-8

class NewsCoverUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :file
  process :store_dimensions

  def store_dir
    'images/news'
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
