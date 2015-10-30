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
                   banners: Banner.app.map { |item| {
                       type: item.type,
                       image: item.image.app.url,
                       url: item.url,
                       link_id: item.link_id,
                       start_date: item.start_date.strftime('%Y-%m-%d'),
                       end_date: item.end_date.strftime('%Y-%m-%d'),
                   } },
               }
           }
  end

  def ads
    render json: Success.new(
               boot: Banner.boot.map { |item| {
                   type: item.type,
                   image: item.image.boot.url,
                   url: item.url,
                   link_id: item.link_id,
                   start_date: item.start_date.strftime('%Y-%m-%d'),
                   end_date: item.end_date.strftime('%Y-%m-%d'),
               } }
           )
  end

  def ver
    version = VERSION[params[:device].downcase][params[:app].downcase]
    render json: Success.new(ver: version['ver'], force: version['force'].to_i, url: version['url'], info: version['info'].split("\n"))
  end


  def online
    render json: Success.new('host' => 'http://www.e-mxing.com/', 're-request' => 1)
  end

  def service
    render json: Success.new(phone: '021-62418505')
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
