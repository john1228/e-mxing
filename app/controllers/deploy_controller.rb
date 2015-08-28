class DeployController < ApplicationController
  def icon
    render json: {
               code: 1,
               data: {
                   icons: {
                       ver: INTERESTS['ver'],
                       items: INTERESTS['items'].collect { |item| item.merge({icon: "#{$host}/images/icons/#{item['id']}.png"}) }
                   }
               }
           }
  end

  def banner
    render json: {
               code: 1,
               data: {
                   banners: Banner.valid.collect { |banner| banner.as_json }
               }
           }
  end

  def ver
    version = VERSION[params[:device].downcase][params[:app].downcase]
    render json: Success.new(ver: version['ver'], force: version['force'].to_i, url: version['url'], info: version['info'].split("\n"))
  end


  def online
    params.each { |k, v|
      logger.info "#{k}::#{v}"
    }
    render json: Success.new('host' => 'http://www.e-mxing.com/', 're-request' => 1)
  end

  def service
    render json: Success.new(phone: '021-51113602')
  end


  def city
    render json: Success.new(
               city: {
                   opened: %w'北京 上海 南京',
                   openning: %w'天津'
               }
           )
  end
end
