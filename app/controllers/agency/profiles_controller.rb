module Agency
  class ProfilesController < BaseController
    def show
      @agency.update(views: @agency.views + 1)
      render json: Success.new(coach: @agency.detail.merge(avatar: {
                                                               original: @coach.profile.avatar.url,
                                                               thumb: @coach.profile.avatar.url
                                                           },
                                                           photowall: @coach.photos.map { |photo|
                                                             {
                                                                 no: photo.id,
                                                                 original: photo.photo.url,
                                                                 thumb: photo.photo.url
                                                             }
                                                           }))
    end
  end
end
