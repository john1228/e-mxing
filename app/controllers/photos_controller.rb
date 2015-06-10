class PhotosController < ApplicationController
  def index
    user = User.find_by_mxid(params[:mxid])
    if user.blank?
      render json: Failure.new('您查看到用户不存在')
    else
      render json: Success.new(
                 photos: user.photos.page(params[:page]||1)
             )
    end
  end

  def create
    photo = @user.photos.new(photo: params[:photo])
    if photo.save
      render json: {code: 1}
    else
      render json: {
                 code: 0,
                 message: '上传照片失败'
             }
    end
  end

  def update
    photo = @user.photos.find_by(id: params[:loc])
    if photo.update(photo: params[:photo])
      render json: {code: 1}
    else
      render json: {
                 code: 0,
                 message: '上传照片失败'
             }
    end
  end

  def destroy
    photo = @user.photos.find_by(id: params[:loc])
    if photo.nil?
      render json: {
                 code: 0,
                 message: '照片不存在或已删除'
             }
    else
      if photo.destroy
        render json: {
                   code: 1
               }
      else
        render json: {
                   code: 0,
                   message: '照片删除失败'
               }

      end
    end
  end
end

