class GroupsController < ApplicationController
  include CheckConcern

  def show
    group = Group.find_by(id: params[:id])
    if group.present?

      render json: {
                 code: 1,
                 data: {
                     group: group.as_json
                 }
             }
    else

    end
  end

  def create
    group = Group.new(name: params[:name], interests: params[:interests], intro: params[:intro])
    if group.save
      (0...10).each { |photo_index|
        group.group_photos.create(photo: params["#{photo_index}"]) if params["#{photo_index}"].present?
      }
      group.group_members.create(user: @user, tag: GroupMember::ADMIN, tag_name: '群主')
      render json: {
                 code: 1
             }
    else
      render json: {
                 code: 0,
                 message: '创建群组失败'
             }
    end
  end

  def join
    group = Group.find_by(id: params[:id])
    if group.nil?
      render json: {
                 code: 0,
                 message: '您加入到群不存在'
             }
    else
      member = group.group_members.new(user: @user)
      if member.save
        render json: {
                   code: 1
               }
      else
        render json: {
                   code: 0,
                   message: '加入群组失败'
               }
      end
    end
  end


  def members
    group = Group.find_by(id: params[:id])
    render json: {
               code: 1,
               data: group.group_members.page(params[:page]||1).collect { |group_member|
                 group_member.as_json
               }
           }
  end

  def destroy
    group = Group.find_by(id: params[:id])
    if group.nil?
      render json: {
                 code: 0,
                 message: '您的群组已解散'
             }
    else
      if group.destroy
        render json: {
                   code: 1
               }
      else
        render json: {
                   code: 0,
                   message: '删除群组失败'
               }
      end
    end
  end
end
