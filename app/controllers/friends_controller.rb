class FriendsController < InheritedResources::Base

  def index
    ids = params[:mxids].split(',').collect { |mxid| mxid - 10000 }
    render json: {
               code: 1,
               data: {
                   profiles: Profile.where(id: ids).collect { |profile|
                     profile.as_json
                   }
               }
           }
  end

  def create
    friend = @user.friends.new(friend_id: params[:friend_id])
    if friend.save
      render json: {code: 1}
    else
      render json: {
                 code: 0,
                 message: '添加好友失败'
             }
    end
  end

  def find
    profiles = Profile.where("'name like ? or id like ?", "%#{params[:keyword]}%", "#{params[:keyword]}'")
    render json: {
               code: 1,
               data: profiles.collect { |profile|
                 profile.as_json
               }
           }
  end
end

