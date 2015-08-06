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
    "#{Time.now.strftime('%Y/%m/%d')}/#{secure_token}.#{file.extension}" if original_filename
  end

  protected
  def secure_token
    Digest::MD5.hexdigest(original_filename + %w'0 1 2 3 4 5 6 7 8 9 a b c d e f g h i j k l m n o p q r s t'.sample(6) + Time.now)
  end
end
