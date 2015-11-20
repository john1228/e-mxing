module Api
  module Course
    class NewsController < ApplicationController
      #私教评论列表
      def index
        render json: Success.new(
                   news: News.category_news(params[:category], sub_category)
               )
      end

      def top
        render json: Success.new(news: News.top_news(params[:category]))
      end
    end
  end
end
