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
end
