class UploadController < ApplicationController
  def active
    device = Device.new(active_params)
    if device.save
      render json: Success.new(token: device.token)
    else
      render json: Failure.new('激活失败')
    end
  end

  def auto_login
    AutoLogin.create(user: Rails.cache.fetch(request.headers[:token]), device: params[:device])
    render json: Success.new
  end


  def data
    #upload_data = JSON(request.body.as_json[0])
    upload_data = JSON(params[:data])
    upload_data.map { |k, v|
      date = Date.parse(k)
      hits = []
      v['c'].map { |point, number|
        hits << {point: point, number: number, date: date, device: params[:device]}
      }
      Hit.create(hits)
      opens = []
      v['o'].map { |item|
        logger.info "#{item[0]}::#{item[1]}"
        opens<< {open: Time.parse(item[0], date), close: Time.parse(item[1], date), device: params[:device]}
      }
      Online.create(opens)
    }
    render json: Success.new
  end

  private
  def active_params
    params.permit(:name, :system, :device, :channel, :version, :ip)
  end
end
