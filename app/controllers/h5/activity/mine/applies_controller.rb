module H5
  module Activity
    class AppliesController < ApplicationController
      before_filter :auth_token

      def index
        h_activity = HActivity.find_by(user: @user, id: params[:id])
        render json: Success.new(apply: h_activity.applies.order(id: :asc).map { |apply|
                                   apply.as_json(except: [:user_id, :activity_id, :updated_at])
                                 })
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