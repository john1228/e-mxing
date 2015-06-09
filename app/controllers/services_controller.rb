class ServicesController < ApiController
  def coaches
    service = Service.find_by_mxid(params[:mxid].to_i)
    if service.nil?
      render json: {code: 0, message: '服务号不存在'}
    else
      render json: {
                 code: 1,
                 data: {
                     coaches: service.service_members.includes(:coach).collect { |member|
                       member.coach.profile.summary_json
                     }
                 }
             }
    end
  end
end
