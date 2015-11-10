# encoding: utf-8

class FilmUploader < CarrierWave::Uploader::Base
  storage :qiniu
  #after :store, :slice #avthumb/m3u8/vb/500k/t/10
  def store_dir
    'videos'
  end

  def hls
    url[0, url.rindex('.')] + '.m3u8'
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
