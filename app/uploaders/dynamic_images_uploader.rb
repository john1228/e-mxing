# encoding: utf-8

class DynamicImagesUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  storage :file
  process :store_dimensions

  def store_dir
    "images/#{model.class.to_s.underscore}"
  end

  version :thumb do
    process :resize_to_fit => [200, 200]
    process :store_dimensions
  end

  def filename
    "#{Time.now.strftime('%Y/%m/%d')}/#{secure_token}.#{file.extension}" if original_filename
  end

  private
  def store_dimensions
    if file && model
      img = ::Magick::Image::read(file.file).first
      model.width, model.height = img.columns, img.rows
    end
  end

  protected
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end
end
