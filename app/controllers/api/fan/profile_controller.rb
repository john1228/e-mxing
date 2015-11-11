module Api
  module Fan
    class ProfileController < ApplicationController
      def show
        enthusiast = Enthusiast.find_by_mxid(params[:mxid])
        if enthusiast.present?
          render json: Success.new(enthusiast: {
                                       mxid: enthusiast.profile.mxid,
                                       name: enthusiast.profile.name,
                                       avatar: enthusiast.profile.avatar.url,
                                       tag: enthusiast.profile.tags,
                                       gender: enthusiast.profile.gender||1,
                                       age: enthusiast.profile.age,
                                       address: enthusiast.profile.address,
                                       signature: enthusiast.profile.signature,
                                       likes: enthusiast.likes.count,
                                       photowall: enthusiast.photos.map { |photo| {no: photo.id, url: photo.photo.url} },
                                       fpg: enthusiast.profile._fitness_program,
                                   })
        else
          render json: Failure.new('您查看的用户不存在')
        end
      end
    end
  end
end
