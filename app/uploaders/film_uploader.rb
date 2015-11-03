# encoding: utf-8

class FilmUploader < CarrierWave::Uploader::Base
  storage :qiniu
  #after :store, :slice

  def store_dir
    'videos'
  end

  def hls
    $hls_host + filename
  end


  def filename
    "#{Time.now.strftime('%Y/%m/%d')}/#{secure_token}.#{file.extension}" if original_filename
  end


  def qiniu_async_ops
    commands = []
  end

  private
  # def slice(args)
  #   VideoProcessJob.perform_later(file.path, store_path, file.extension)
  # end

  protected
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end
end
