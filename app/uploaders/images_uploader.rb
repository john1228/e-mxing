# encoding: utf-8
class ImagesUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :file

  def store_dir
    "images/#{model.class.to_s.underscore}"
  end

  version :thumb do
    process :resize_to_fit => [300, 300]
  end

  def filename
    "#{SecureRandom.uuid}.#{file.extension}" if original_filename.present?
  end
end
