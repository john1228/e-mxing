module Mine
  class ConcernsController < BaseController
    def index
      render json: Success.new(
                 concerned: Sku.joins(:concerneds).select("skus.*,st_distance(skus.coordinate, 'POINT(#{params[:lng]} #{params[:lat]})') as distance").
                     where(concerneds: {user_id: @me.id}).order('concerneds.id desc').page(params[:page]||1)
             )
    end

    def create
      concerned = @me.concerns.find_or_create_by(sku: params[:course])
      if concerned.present?
        render json: Success.new
      else
        render json: Failure.new('关注课程失败')
      end
    end

    def destroy
      concerned = @me.concerns.find_by(sku: params[:course])
      if concerned.destroy
        render json: Success.new
      else
        render json: Failure.new('取消关注失败')
      end
    end
  end
end
