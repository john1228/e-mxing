module Agency
  class AgenciesController < BaseController
    def list
      city = URI.decode(request.headers[:city]) rescue '上海'
      agencies = Service.select("profiles.*,st_distance(places.lonlat, 'POINT(#{params[:lng]||0} #{params[:lat]||0})') as distance").
          includes(:profile, :place).
          where('profiles.name LIKE ? or profiles.address LIKE ?', "#{params[:keyword]||''}%", "#{params[:keyword]||''}%").
          where('profiles.address LIKE ?', "#{city}%").
          order('distance asc').
          order(id: :desc).
          page(params[:page]||1)
      agencies = Service.select("profiles.*,st_distance(places.lonlat, 'POINT(#{params[:lng]} #{params[:lat]})') as distance").order('distance asc').take(3) if agencies.blank?
      render json: Success.new(agency: agencies)
    end

    def hot
      render json: Success.new(hot: %w'凌空SOHO 徐家汇')
    end

    def show
      render json: Success.new(agency: @service.detail)
    end
  end
end
