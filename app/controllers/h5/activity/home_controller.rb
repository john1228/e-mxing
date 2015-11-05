module H5
  module Activity
    class HomeController < ApplicationController
      def index
        render json: Success.new(activity: HActivity.order(id: :desc).page(params[:page]||1).map { |h_activity|
                                   h_activity.as_json(only: [:cover, :title, :start, :end, :address, :fee, :apply_count])
                                 })
      end

      def show
        h_activity = HActivity.find(params[:id])
        render Success.new(activity: h_activity.as_json(include: :intro))
      end


      private
      def activity_params
        params.permit(:title, :cover, :start, :end, :enroll, :address, :gather, :limit, :fee, :stay, :insurance, :tip, :bak,
                      intro: [:title, :desc, :image])
      end
    end
  end
end