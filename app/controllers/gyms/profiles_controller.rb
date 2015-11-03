module Gyms
  class ProfilesController < BaseController
    def show
      render json: Success.new(coach: @coach.detail.merge(avatar: {
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
