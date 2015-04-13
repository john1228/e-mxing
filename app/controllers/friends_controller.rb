class FriendsController < InheritedResources::Base

  def index
    ids = params[:mxids].split(',').collect { |mxid| mxid.to_i - 10000 }
    render json: {
               code: 1,
               data: {
                   profiles: Profile.where(id: ids).collect { |profile|
                     profile.as_json
                   }
               }
           }
  end

  def find
    profiles = Profile.where("'name like ? or id like ?", "%#{params[:keyword]}%", "#{params[:keyword]}'")
    render json: {
               code: 1,
               data: profiles.collect { |profile| profile.summary_json }
           }
  end
end

