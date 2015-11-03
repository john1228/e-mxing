module H5
  module Activity
    class HomeController < ApplicationController
      before_filter :auth_token

      def join
        render json: Success.new(activity: HActivity.where(id: Apply.where(user: @user).pluck(:activity_id)).map { |h_activity|
                                   h_activity.as_json(only: [:cover, :title, :start, :end, :address, :fee, :applies_count])
                                 })
      end

      def release
        render json: Success.new(activity: HActivity.where(user: @user).map { |h_activity|
                                   h_activity.as_json(only: [:cover, :title, :start, :end, :address, :fee, :applies_count])
                                 })
      end

      def create
        h_activity = HActivity.new(activity_params)
        if h_activity.save
          render json: Success.new
        else
          render json: Failure.new(h_activity.errors.messages)
        end
      end

      private
      def activity_params
        params.permit(:title, :cover, :start, :end, :enroll, :address, :gather, :limit, :fee, :stay, :insurance, :tip, :bak,
                      intro: [:title, :desc, :image])
      end

      def auth_token
        @user = Rails.cache.read(request.headers[:token])
      end
    end
  end
end