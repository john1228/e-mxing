module Business
  class CommentsController < BaseController
    #获取线上学员列表
    def index
      render json: Success.new(
                 comment: Comment.where(sku: Sku.where(seller_id: @coach.id).pluck(:id)).order(id: :desc).map { |comment|
                   {
                       user: {
                           mxid: comment.user.profile.mxid,
                           name: comment.user.profile.name,
                           avatar: comment.user.profile.avatar.url
                       },
                       course: {
                           id: comment.course.id,
                           name: comment.course.course_name,
                           cover: comment.course.course_cover,
                           during: comment.course.course_during,
                           price: comment.course.selling_price
                       },
                       content: comment.content,
                       image: comment.image.map { |image| image.url },
                       created: comment.created_at.localtime.strftime('%Y-%m-%d %H:%M:%S')
                   }
                 }
             )
    end
  end
end