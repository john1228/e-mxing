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

  version :share do
    process :resize_to_fill => [250, 250]
  end


  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def filename
    "#{SecureRandom.uuid}.#{file.extension}" if original_filename.present?
  end
end
