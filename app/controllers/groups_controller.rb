class GroupsController < ApiController
  def mine
    groups = Group.where(easemob_id: params[:ids].split(','))
    render json: Success.new(
               groups: groups.collect { |group| group.summary_json }
           )
  end

  def show
    group = Group.find_by(easemob_id: params[:id])
    if group.blank?
      render json: Failure.new('您查看到群已解散')
    else
      render json: Success.new(group: group)
    end
  end

  def create
    group = Group.new(name: params[:name], interests: params[:interests], intro: params[:intro], owner: @user.profile_mxid, lat: params[:lat], lng: params[:lng])
    if group.save
      (0...10).each { |photo_index| group.group_photos.create(photo: params["#{photo_index}"]) if params["#{photo_index}"].present? }
      render json: Success.new(group: group)
    else
      render json: Failure.new('创建群组失败')
    end
  end

  def update
    group = Group.find_by(id: params[:id])
    if group.owner.eql?(@user.profile_mxid)
      if group.update(update_params)
        group.group_photos.where(id: params[:del].split(',')).delete_all unless params[:del].nil?
        (0...10).each { |photo_index| group.group_photos.create(photo: params["#{photo_index}"]) if params["#{photo_index}"].present? }
        render json: Success.new
      else
        render json: Failure.new('修改群信息失败')
      end
    else
      render json: Failure.new('您不是群主,不能更新群信息')
    end
  end

  def destroy
    group = Group.find_by(id: params[:id])
    if group.nil?
      render json: Failure.new('您的群组已解散')
    else
      if group.destroy
        render json: Success.new
      else
        render json: Failure.new('删除群组失败')
      end
    end
  end

  private
  def update_params
    params.permit(:name, :interests, :intro)
  end
end
