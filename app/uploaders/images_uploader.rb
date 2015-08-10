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
    "#{Time.now.strftime('%Y/%m/%d')}/#{secure_token}.#{file.extension}" if original_filename
  end

  private
  def secure_token
    if parent_version.present?
      img = MiniMagick::Image::new(parent_version.file.file)
    else
      img = MiniMagick::Image::new(file.file)
    end
    Digest::MD5::hexdigest("#{img.size}|#{img.width}|#{img.height}")
  end
end
