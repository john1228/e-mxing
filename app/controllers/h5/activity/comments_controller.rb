module H5
  module Activity
    class CommentsController < ApplicationController
      def index
        h_activity = HActivity.find(params[:id])
        render json: Success.new(comment: h_activity.comments.order(id: :desc).page(params[:page]||1).map { |comment|
                                   comment.as_json(only: [:content, :image, :created_at])
                                 })
      end

      def create
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