# encoding: utf-8

class FilmUploader < CarrierWave::Uploader::Base

  storage :file
  after :store, :slice

  def store_dir
    "videos/#{model.class.to_s.underscore}"
  end

  def hls
    $hls_host + url.gsub("/#{store_dir}", '').gsub(file.extension, 'm3u8')
  end


  def filename
    "#{Time.now.strftime('%Y/%m/%d')}/#{secure_token}.#{file.extension}" if original_filename
  end

  private
  def slice(args)
    VideoProcessJob.perform_later(file.path, file.extension)
  end

  protected
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end
end
