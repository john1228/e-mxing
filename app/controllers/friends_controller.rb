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
    case params[:type]
      when 'person'
        result = User.joins(:profile).where('profiles.name  ~* ? or profiles.id=?', params[:keyword], (params[:keyword].to_i-Profile::BASE_NO))
      when 'service'
        result = Service.joins(:profile).where('profiles.name  ~* ? or profiles.id=?', params[:keyword], (params[:keyword].to_i-Profile::BASE_NO))
      when 'group'
        result = Group.where('groups.name  ~* ? or groups.id = ?', params[:keyword], params[:keyword].to_i)
      else
        result = []
    end
    render json: {
               code: 1,
               data: {
                   "#{params[:type]}s" => result.collect { |item| item.summary_json }
               }
           }
  end
end

