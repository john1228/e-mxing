module Gyms
  class CommentsController < BaseController
    before_action :fetch_course, only: [:coach, :comments, :concern]
    before_action :verify_auth_token, only: [:buy, :concern, :show]
    #私教评论列表
    def index
      render json: Success.new(
                 comments: []
             )
    end
    #发表私教评论
    def create

    end

    private
    def fetch_course
      @course = Course.find_by(id: params[:course])
      render json: {code: 0, message: '课程不存在'} if @course.blank?
    end

  end
end
