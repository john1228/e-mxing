module Agency
  class BaseController < ApplicationController
    before_action :verify_agency, except: :index
  
    def index
      city = URI.decode(request.headers[:city]) rescue '上海'
      agencies = Service.select("profiles.*,st_distance(places.lonlat, 'POINT(#{params[:lng]||0} #{params[:lat]||0})') as distance").
          includes(:profile, :place).
          where('profiles.name LIKE ? or profiles.address LIKE ?', "#{params[:keyword]||''}%", "#{params[:keyword]||''}%").
          where('profiles.address LIKE ?',"#{city}%").
          order('distance asc').
          order(id: :desc).
          page(params[:page]||1)
      agencies = Service.select("profiles.*,st_distance(places.lonlat, 'POINT(#{params[:lng]} #{params[:lat]})') as distance").order('distance asc').take(3) if agencies.blank?
      render json: Success.new(agency: agencies)
    end
    private
    def verify_agency
      @agency = Service.find_by_mxid(params[:mxid])
      render json: Failure.new('您查看的服务号不存在') if @agency.nil?
    end
  end
end
