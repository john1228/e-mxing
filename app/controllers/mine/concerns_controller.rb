module Mine
  class ConcernsController < BaseController
    def index
      render json: Success.new(
                 concerned: @user.concerns.page(params[:page]||1)
             )
    end

    def create
      concerned = @user.concerns.find_or_create_by(sku: params[:course ])
      if concerned.present?
        render json: Success.new
      else
        render json: Failure.new('关注课程失败')
      end
    end

    def destroy
      concerned = @user.concerns.find_by(course_id: params[:course])
      if concerned.destroy
        render json: Success.new
      else
        render json: Failure.new('取消关注失败')
      end
    end
  end
end
