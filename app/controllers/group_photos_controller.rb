class GroupPhotosController < ApplicationController
  include GroupManager

  def index
    render json: {
               code: 1,
               data: {photos: @group.group_photos.collect { |group_photo| group_photo.as_json }}
           }
  end

  def create
    group_photo = @group.group_photos.new(photo: params[:photo])
    if group_photo.save
      render json: {code: 1}
    else
      render json: {code: 0, message: '添加群相册失败'}
    end
  end

  def delete
    group_photo = @group.group_photos.find_by(id: params[:id])
    if group_photo.blank?
      render json: {code: 0, message: '照片不存在'}
    else
      if group_photo.destroy
        render json: {code: 1}
      else
        render json: {code: 0, message: '删除照片失败'}
      end
    end
  end
end
