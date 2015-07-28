class PhotosController < ApiController
  def index
    render json: Success.new(photos: @user.photos.page(params[:page]||1))
  end

  def create
    photo = @user.photos.new(photo: params[:photo])
    if photo.save
      render json: Success.new
    else
      render json: Failure.new('照片上传失败')
    end
  end

  def update
    photo = @user.photos.new(photo: params[:photo])
    if photo.save
      render json: Success.new
    else
      render json: Failure.new('照片上传失败')
    end
  end

  def destroy
    photo = @user.photos.find_by(id: params[:id])
    if photo.nil?
      render json: Failure.new('照片不存在或已删除')

    else
      if photo.destroy
        render json: Success.new
      else
        render json: Failure.new('照片删除失败')
      end
    end
  end
end

