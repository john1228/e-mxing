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
        result = User.includes(:profile).where('profiles.name  ~* ?', params[:keyword])
      when 'service'
        result = Service.includes(:profile).where('profiles.name  ~* ?', params[:keyword])
      when 'group'
        result = Group.where('groups.name  ~* ?', params[:keyword])
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

