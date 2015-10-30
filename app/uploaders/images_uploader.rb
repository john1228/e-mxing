# encoding: utf-8
class ImagesUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :qiniu
  process :resize_to_limit => [1024, 1024]
  after :store, :update_model
  def store_dir
    'images/course'
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

  def update_model(args)
    if model.is_a?(Course)
      Sku.where('sku LIKE ? ', 'CC' + '-' + '%06d' % model.id + '%').update_all(course_cover: model.image.first.url)
    elsif model.is_a?(ServiceCourse)
      Sku.where('sku LIKE ? ', 'SC' + '-' + '%06d' % model.id + '%').update_all(course_cover: model.image.first.url)
    end
  end
end
