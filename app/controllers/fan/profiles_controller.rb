module Fan
  class ProfilesController < BaseController
    def show
      render json: Success.new(enthusiast: @enthusiast.as_json.merge(avatar: {
                                                                         original: @enthusiast.profile.avatar.url,
                                                                         thumb: @enthusiast.profile.avatar.url
                                                                     },
                                                                     photowall: @enthusiast.photos.map { |photo|
                                                                       {
                                                                           no: photo.id,
                                                                           original: photo.photo.url,
                                                                           thumb: photo.photo.url
                                                                       }
                                                                     }
                               ))
    end
  end
end
