module Agency
  class ProfilesController < BaseController
    def show
      @agency.update(views: @agency.views + 1)
      render json: Success.new(coach: @agency.detail.merge(avatar: {
                                                               original: @agency.profile.avatar.url,
                                                               thumb: @agency.profile.avatar.url
                                                           },
                                                           photowall: @agency.photos.map { |photo|
                                                             {
                                                                 no: photo.id,
                                                                 original: photo.photo.url,
                                                                 thumb: photo.photo.url
                                                             }
                                                           }))
    end
  end
end
