# encoding: utf-8

class PhotosUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :file
  process :resize_to_limit => [2080, nil]

  def store_dir
    'images/photo'
  end

  version :thumb do
    process :resize_to_fit => [300, nil]
  end

  version :share do
    process :resize_to_fill => [250, 250]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
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
