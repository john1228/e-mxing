class VideoProcessJob < ActiveJob::Base
  queue_as :default
  rescue_from Exception do
    retry_job wait: 5.minutes, queue: :low_priority
  end

  def perform(file_path, store_path, file_extension)
    file_name = file_path.gsub("#{Rails.root}/public/videos/dynamic_film/", "")
    hls_name = "#{Rails.root}/public/videos/hls/#{file_name.gsub(store_path, "").gsub(file_extension, 'm3u8')}"
    FileUtils.mkdir_p File.dirname(hls_name) unless File.exists?(hls_name)
    split_command = "ffmpeg -v 9 -re -i #{file_path} -acodec libmp3lame -c:v libx264 -flags -global_header -map 0 -f segment -segment_time 10 -segment_list #{hls_name} -segment_format mpegts #{hls_name}%04d.ts"
    puts split_command
    system(split_command)
  end
end
