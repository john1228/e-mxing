module Gyms
  class CommentsController < BaseController
    #私教评论列表
    def list
      comment = {}
      case params[:list]
        when 'coach'
          coach = Coach.find_by_mxid(params[:mxid])
          comments = Comment.where(course_id: coach.id)
          if (params[:page]||1).to_i.eql?(1)
            comment = comment.merge(count: comments.count, items: comments.page(1))
          else
            comment = comment.merge(items: comments.page(1))
          end
        when 'course'
          comments = Comment.where(course_id: params[:id])
          if (params[:page]||1).to_i.eql?(1)
            comment = comment.merge(count: comments.count, items: comments.page(1))
          else
            comment = comment.merge(items: comments.page(1))
          end
        else
          comment = comment.merge(count: 0, items: [])
      end
      render json: Success.new(comment)
    end
  end
end
