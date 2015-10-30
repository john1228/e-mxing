module Api
  class RecommendController < ApplicationController
    def gyms
      city = URI.decode(request.headers[:city]) rescue '上海'
      render json Success.new(
                      gyms: Profile.gyms.joins(:place, :user).select("profiles.id,profiles.name, st_distance(skus.coordinate, 'POINT(#{params[:lng]} #{params[:lat]})') as distance").
                          where('city = ?', city).order(distance: :desc).order(id: :desc).page(params[:page]||1)
                  )
    end

    def boutique
      render json: Success.new(
                 venues: News.order(id: :desc).page(params[:page]||1)
             )
    end

    def knowledge
      render json: Success.new(
                 knowledge: News.order(id: :desc).page(params[:page]||1)
             )
    end

    def coupon
      @user = Rails.cache.fetch(request.headers[:token])
      render json: Success.new(
                 coupon: Coupon.where('end_date >= ? and active=? and amount > used', Date.today, true).order(end_date: :asc).
                     page(params[:page]||1).map { |coupon|
                   if @user.blank?
                     coupon.as_json.merge(have: 0)
                   else
                     coupon.as_json.merge(have: @user.wallet.coupons.include?(coupon.id) ? 1 : 0)
                   end
                 }
             )
    end

    def talent
      week_rank = (Rails.cache.fetch('week')||{})
      week_rank.delete_if { |k, v| User.find_by(id: k).blank? }
      month_rank = (Rails.cache.fetch('month')||{})
      month_rank.delete_if { |k, v| User.find_by(id: k).blank? }
      render json: Success.new(
                 talent: {
                     week: {
                         week: Date.today.strftime('%U').to_i,
                         items: week_rank.map { |k, v|
                           user = User.find_by(id: k)
                           {user: user.summary_json, likes: v} if user.present?
                         }
                     },
                     month: {
                         items: month_rank.map { |k, v|
                           user = User.find_by(id: k)
                           {user: user.summary_json, likes: v} if user.present?
                         }
                     }
                 }
             )
    end
  end
end
