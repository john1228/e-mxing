class GroupPhotosController < ApiController
  def index
    group = Group.find_by(id: params[:group_id])
    if group.blank?
      render json: {
                 code: 0,
                 message: '您查看到群不存在'
             }
    else
      render json: {
                 code: 1,
                 data: {photos: group.group_photos.collect { |group_photo| group_photo.as_json }}
             }
    end
  end

  def create
    group = Group.find_by(id: params[:group_id])
    render json: {code: 0, message: '该群不存在'} if group.blank?
    if group.owner.eql?(@user.id)
      group_photo = group.group_photos.new(photo: params[:photo])
      if group_photo.save
        render json: {code: 1, data: {photo: group_photo.as_json}}
      else
        render json: {code: 0, message: '添加群相册失败'}
      end
    else
      render json: {code: 0, message: '您不是群主，不能进行此操作'}
    end
  end

  def destroy
    group = Group.find_by(id: params[:group_id])
    if group.blank?
      render json: Failure.new('该群不存在')
    else
      if group.owner.eql?(@user.profile.mxid)
        GroupPhoto.where(id: params[:id]).destroy_all
        render json: Success.new
      else
        render json: Failure.new('您不是群主，不能进行此操作')
      end
    end

  end
end
