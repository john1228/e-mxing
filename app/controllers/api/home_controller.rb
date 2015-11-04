module Api
  class HomeController < ApplicationController
    def index
      render json: Success.new(
                 tag: Category.all.map { |category|
                   online_courses = Sku.online.where(course_type: category.item).order(selling_price: :asc)
                   {
                       tag: category.name,
                       backgournd: category.background.url,
                       amount: online_courses.count,
                       lowest: online_courses.first.selling_price
                   }
                 }
             )
    end

    def search
      keyword = params[:keyword]
      case params[:cat]
        when 'venues'
          venues = search_venues(keyword, params[:page]||1)
          render json: Success.new(venues: venues)
        when 'course'
          courses = search_course(keyword, params[:page]||1)
          render json: Success.new(course: courses)
        when 'knowledge'
          knowledge = search_knowledge(keyword, params[:page]||1)
          render json: Success.new(knowledge: knowledge)
        when 'user'
          user = search_user(keyword, params[:page]||1)
          render json: Success.new(user: user)
        else
          venues = search_venues(keyword, params[:page]||1)
          if venues.present?
            render json: Success.new(venues: venues.map { |venue|
                                       {
                                           mxid: venue.profile.mxid,
                                           name: venue.profile.name,
                                           avatar: venue.profile.avatar.url,
                                           background: (venue.photos.first.photo.url rescue ''),
                                           address: venue.profile.province.to_s + venue.profile.city.to_s + venue.profile.address.to_s,
                                           distance: venue.attributes['distance'].to_i,
                                           coach_count: venue.coaches.count,
                                           sale: venue.courses.online.count,
                                           tag: venue.profile.tag,
                                           auth: venue.profile.auth,
                                           floor: (venue.courses.online.order(selling_price: :asc).first.selling_price rescue ''),
                                       }
                                     })
          else
            courses = search_course(keyword, params[:page]||1)
            if courses.present?
              render json: Success.new(course: courses)
            else
              knowledge = search_knowledge(keyword, params[:page]||1)
              if knowledge.present?
                render json: Success.new(knowledge: knowledge)
              else
                user = search_user(keyword, params[:page]||1)
                if user.present?
                  render json: Success.new(user: user)
                else
                  render json: Success.new
                end
              end
            end
          end
      end
    end

    def hot_key
      render json: Success.new(key: %w'综合训练 瑜伽 力量 跆拳道 有氧操 羽毛球')
    end

    protected
    def search_venues(keyword, page)
      Service.joins(:place).select("users.*,st_distance(places.lonlat, 'POINT(#{params[:lng]||0} #{params[:lat]||0})') as distance").
          where('profiles.name LIKE ? or profiles.address LIKE ?', keyword, keyword).order('distance asc').order(id: :desc).page(page)
    end

    def search_course(keyword, page)
      Sku.online.select("skus.*, st_distance(skus.coordinate, 'POINT(#{params[:lng]||0} #{params[:lat]||0})') as distance").
          where('sku.course_name LIKE ? or sku.address LIKE ?', keyword, keyword).order('distance asc').order(id: :desc).page(page)
    end

    def search_knowledge(keyword, page)
      News.where('title LIKE ? or content LIKE ?', keyword, keyword).order(id: :desc).page(page)
    end

    def search_user(keyword, page)
      Profile.joins(:user).where.not('identity <> ?', Profile.identities[:service]).where('profiles.name LIKE ?', keyword).page(page)
    end
  end
end
