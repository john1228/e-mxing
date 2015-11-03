module Fan
  class ProfilesController < BaseController
    def show
      enthusiast = Enthusiast.find_by_mxid(params[:mxid])
      render json: Success.new(enthusiast: enthusiast.detail.merge(photowall: enthusiast.photos.map { |photo|
                                                                     {
                                                                         no: photo.id,
                                                                         url: photo.url
                                                                     }
                                                                   }))
    end
  end
end
