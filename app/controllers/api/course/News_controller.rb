module Api
  module Course
    class NewsController < ApplicationController
      #私教评论列表
      def index
        case params[:sub_category]
          when '场馆推荐'
            sub_category = News.tags[:venues]
          when '私教专访'
            sub_category = News.tags[:gyms]
          else
            sub_category = News.tags[:knowledge]
        end
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
