class ImageWorker
  include Sidekiq::Worker

  def perform(image_url, image_name)
    image = Magick::Image.read(image_url).first
    width, height = image.columns, image.rows
    rate = (width > height) ? (width / 260.to_f) : (height / 260.to_f)
    if rate >0
      default = image.resize(width/rate, height/rate)
    else
      default = image.resize(width, height)
    end
    default_image = "#{Rails.root}/public/images/profile/default/#{image_name}.jpg"
    FileUtils.mkdir_p File.dirname(default_image) unless File.exists?(default_image)
    default.write(default_image)
  end
end


