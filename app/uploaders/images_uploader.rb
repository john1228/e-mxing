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
    "#{Time.now.strftime('%Y/%m/%d')}/#{Digest::MD5.hexdigest(original_filename)}.#{file.extension}" if original_filename
  end
end
