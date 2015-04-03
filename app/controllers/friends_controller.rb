class FriendsController < InheritedResources::Base

  def index
    render json: {
               code: 1,
               message: 'success',
               data: User.where(id: JSON(params[:ids])).collect { |user|
                 profile = user.profile
                 {
                     no: user.id,
                     username: user.id.to_s,
                     name: profile.name,
                     thumb: url_for($host+ profile.icon.url(:thumb)),
                     original: url_for($host+ profile.icon.url),
                     gender: profile.gender,
                     signature: profile.signature
                 }
               }
           }
  end

  def create
    friend = @user.friends.new(friend_id: params[:friend_id])
    if friend.save
      render json: {
                 code: 1,
                 message: 'success'
             }
    else
      render json: {
                 code: 0,
                 message: friend.errors
             }
    end
  end

  def find
    profiles = Profile.where("name like ? or id like ?", "%#{params[:keyword]}%", "#{params[:keyword]}")
    render json: {
               code: 1,
               message: 'success',
               data: profiles.collect { |profile|
                 {
                     no: profile.user_id,
                     username: profile.user_id.to_s,
                     name: profile.name,
                     thumb: profile.icon.start_with?('http')||profile.icon.blank? ? profile.icon : url_for("#{$img_host}/profile/avatar/130x130/#{profile.icon}"),
                     original: profile.icon.start_with?('http')||profile.icon.blank? ? profile.icon : url_for("#{$img_host}/profile/avatar/#{profile.icon}"),
                     gender: profile.gender,
                     signature: profile.signature
                 }
               }
           }
  end
end

