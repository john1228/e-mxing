module Agency
  class AgenciesController < BaseController
    def list
      # city = URI.decode(request.headers[:city]) rescue '上海'
      page = (params[:page]||1).to_i
      agencies = Service.select("users.id,st_distance(places.lonlat, 'POINT(#{params[:lng]||0} #{params[:lat]||0})') as distance").
          joins(:profile, :place).
          where('profiles.name LIKE ? or profiles.address LIKE ?', "%#{params[:keyword]||''}%", "%#{params[:keyword]||''}%").
          # where('profiles.address LIKE ?', "%#{city}%").
          order('distance asc').
          order(id: :desc).
          page(page)
      agencies = Service.select("users.id,st_distance(places.lonlat, 'POINT(#{params[:lng]} #{params[:lat]})') as distance").joins(:profile, :place).where('profiles.address LIKE ?', "#{city}%").order('distance asc').take(3) if agencies.blank?&&page.eql?(1)
      render json: Success.new(agency: agencies)
    end

    def hot
      render json: Success.new(hot: %w'凌空SOHO 徐家汇 人民广场 中山公园 外滩 南京西路')
    end
  end
end
