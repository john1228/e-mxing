# encoding: utf-8

class FilmUploader < CarrierWave::Uploader::Base
  storage :file
  after :store, :slice

  def store_dir
    "videos/#{model.class.to_s.underscore}"
  end

  def hls_url
    if file.extension.blank?
      to_s.end_with?('.') ? ($hls_host + to_s.gsub("/#{store_dir}", '') + 'm3u8') : ($hls_host + to_s.gsub("/#{store_dir}", '') + '.' + 'm3u8')
    else
      $hls_host + to_s.gsub("/#{store_dir}", '').gsub(file.extension, 'm3u8')
    end
  end


  def filename
    "#{Time.now.strftime('%Y/%m/%d')}/#{secure_token}.#{file.extension}" if original_filename
  end

  private
  def slice(args)
    film = FFMPEG::Movie.new(file.file)
    #model.length = film.duration
    #FilmWorker.perform_async(store_dir, self.to_s, file.extension) if file.present?
  end

  protected
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end
end
