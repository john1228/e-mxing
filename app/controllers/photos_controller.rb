class PhotosController < ApiController
  def index
    if @user.profile.identity.eql?(2)
      service = Service.find(@user.id)
      render json: Success.new(
                 photos: service.service_photos.page(params[:page]||1)
             )
    else
      render json: Success.new(
                 photos: @user.photos.page(params[:page]||1)
             )
    end
  end

  def create
    if @user.profile.identity.eql?(2)
      service = Service.find(@user.id)
      photo = service.service_photos.new(photo: params[:photo])
    else
      photo = @user.photos.new(photo: params[:photo])
    end
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
    if @user.profile.identity.eql?(2)
      service = Service.find(@user.id)
      photo = service.service_photos.new(photo: params[:photo])
    else
      photo = @user.photos.new(photo: params[:photo])
    end
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
    if @user.profile.identity.eql?(2)
      service = Service.find(@user.id)
      photo = service.service_photos.new(photo: params[:photo])
    else
      photo = @user.photos.new(photo: params[:photo])
    end
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

