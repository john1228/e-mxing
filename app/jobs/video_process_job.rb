class VideoProcessJob < ActiveJob::Base
  queue_as :default
  rescue_from Exception do
    retry_job wait: 5.minutes, queue: :low_priority
  end

  def perform(file_path)
    file_name = file_path.gsub("#{Rails.root}/public/videos/dynamic_film/", "")
    if file_extension.blank?
      video_hls_name = file_name.end_with?('.') ? (file_name + 'm3u8') : (file_name + '.' + 'm3u8')
    else
      video_hls_name = file_path.gsub(store_path, "").gsub(file_extension, 'm3u8')
    end
    video_hls_path = "#{Rails.root}/public/videos/hls"
    FileUtils.mkdir_p File.dirname(video_hls_path + video_hls_name) unless File.exists?(video_hls_path + video_hls_name)
    split_command = "ffmpeg -v 9 -re -i #{Rails.root + '/' + file_path} -acodec libmp3lame -c:v libx264 -flags -global_header -map 0 -f segment -segment_time 10 -segment_list #{video_hls_path + video_hls_name} -segment_format mpegts #{video_hls_path + '/' + video_hls_name}%04d.ts"
    puts split_command
    system(split_command)
  end
end
