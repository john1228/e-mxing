class GroupsController < ApplicationController
  include LoginManager

  def mine
    groups = Group.where(easemob_id: params[:ids].split(','))
    render json: {
               code: 1,
               data: {
                   groups: groups.collect { |group| group.summary_json }
               }
           }
  end

  def show
    group = Group.find_by(easemob_id: params[:id])
    if group.blank?
      render json: {code: 0, message: '您查看到群已解散'}
    else
      render json: {code: 1, data: {group: group.as_json}}
    end
  end

  def create
    group = Group.new(name: params[:name], interests: params[:interests], intro: params[:intro], owner: @user.profile_mxid, lat: params[:lat], lng: params[:lng])
    if group.save
      (0...10).each { |photo_index| group.group_photos.create(photo: params["#{photo_index}"]) if params["#{photo_index}"].present? }
      render json: {code: 1}
    else
      render json: {code: 0, message: '创建群组失败'}
    end
  end

  def update
    group = Group.find_by(id: params[:id])
    if group.owner.eql?(@user.profile_mxid)
      if group.update(update_params)
        render json: {code: 1}
      else
        render json: {code: 0, message: '修改群信息失败'}
      end
    else
      render json: {code: 0, message: '您不是群主,不能更新群信息'}
    end
  end

  def destroy
    group = Group.find_by(id: params[:id])
    if group.nil?
      render json: {code: 0, message: '您的群组已解散'}
    else
      if group.destroy
        render json: {code: 1}
      else
        render json: {code: 0, message: '删除群组失败'}
      end
    end
  end

  private
  def update_params
    params.permit(:name, :interests, :intro)
  end
end
