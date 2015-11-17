module Api
  class RecommendController < ApplicationController
    def gyms
      #city = URI.decode(request.headers[:city]) rescue '上海'
      render json: Success.new(
                 gyms: Profile.coach.joins(:place, :user).
                     select("profiles.id,profiles.name,profiles.avatar,profiles.gender,profiles.birthday,profiles.signature,profiles.identity, st_distance(places.lonlat, 'POINT(#{params[:lng]||0} #{params[:lat]||0})') as distance").
                     order('distance asc').order(id: :desc).page(params[:page]||1).map { |profile|
                   profile.summary_json.merge(distance: profile.attributes['distance'])
                 }
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
      week_rank.delete_if { |k,| User.find_by(id: k).blank? }
      month_rank = (Rails.cache.fetch('month')||{})
      month_rank.delete_if { |k,| User.find_by(id: k).blank? }
      render json: Success.new(
                 talent: {
                     week: {
                         week: Date.today.strftime('%U').to_i,
                         items: week_rank.map { |k, v|
                           user = User.find_by(id: k)
                           {user: user, likes: v} if user.present?
                         }
                     },
                     month: {
                         items: month_rank.map { |k, v|
                           user = User.find_by(id: k)
                           {user: user, likes: v} if user.present?
                         }
                     }
                 }
             )
    end

    def venues
      venues = Service.joins(:place).select("users.*,st_distance(places.lonlat, 'POINT(#{params[:lng]||0} #{params[:lat]||0})') as distance").
          order('distance asc').order(id: :desc).take(2)
      render json: Success.new(venues: venues.map { |venue|
                                 {
                                     mxid: venue.profile.mxid,
                                     name: venue.profile.name,
                                     avatar: venue.profile.avatar.url,
                                     bg: (venue.photos.first.photo.url rescue ''),
                                     address: venue.profile.province.to_s + venue.profile.city.to_s + venue.profile.address.to_s,
                                     distance: venue.attributes['distance'].to_i,
                                     coach_count: venue.coaches.count,
                                     sale: venue.courses.online.count,
                                     tags: venue.profile.tags,
                                     auth: venue.profile.auth,
                                     floor: (venue.courses.online.order(selling_price: :asc).first.selling_price rescue ''),
                                 }
                               })
    end
  end
end
