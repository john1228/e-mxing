module Api
  class HomeController < ApplicationController
    def index
      group_sku = Sku.online.where.not(tag: nil).group(:tag).count
      render json: Success.new(
                 group_sku.map { |k, v|
                   tag = Tag.course.find_by(name: k)
                   lowest = Sku.online.where(tag: k).order(selling_price: :asc).first
                   {
                       name: k,
                       background: tag.background,
                       amount: v,
                       floor_price: lowest.selling_price
                   }
                 }
             )
    end

    def search
      keyword = params[:keyword]
      venues = Service.joins(:place).select("users.*,st_distance(places.lonlat, 'POINT(#{params[:lng]||0} #{params[:lat]||0})') as distance").
          where('profiles.name LIKE ? or profiles.address LIKE ?', keyword, keyword).order('distance asc').order(id: :desc).page(params[:page]||1)
      if venues.present?
        render json: Success.new(venues: venues)
      else
        #课程的地址采用的是服务号的地址，因此课程不需再检索地址
        courses = Sku.online.select("skus.*, st_distance(skus.coordinate, 'POINT(#{params[:lng]} #{params[:lat]})') as distance").
            where('sku.course_name LIKE ?', keyword).order('distance asc').order(id: :desc).page(params[:page]||1)
        if courses.present?
          render json: Success.new(course: courses)
        else
          knowledge = News.where('title LIKE ? or content LIKE ?', keyword, keyword).order(id: :desc).page(params[:page]||1)
          if knowledge.present?
            render json: Success.new(knowledge: knowledge)
          else
            user = Profile.joins(:user).where.not('identity <> ?', Profile.identities[:service]).where('profiles.name LIKE ?', keyword).page(params[:page]||1)
            if user.present?
              render json: Success.new(user: user)
            else
              render json: Success.new
            end
          end
        end
      end
    end

    def hot_key
      render json: Success.new(key: %w'综合训练 瑜伽 力量 跆拳道 有氧操 羽毛球')
    end
  end
end
