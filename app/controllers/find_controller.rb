class FindController < ApplicationController
  include LoginManager
  include FindManager

  def upload
    if @user.place.present?
      @user.place.update(lonlat: "POINT(#{params[:lng]} #{params[:lat]})")
    else
      @user.create_place(lonlat: "POINT(#{params[:lng]} #{params[:lat]})")
    end
    render json: {
               code: 1
           }
  end

  def list
    case params[:type]
      when 'dynamics'
        data = {dynamics: dynamics}
      when 'persons'
        data = {persons: persons}
      when 'groups'
        data = {groups: groups}
      when 'services'
        data = {services: services}
      when 'news'
        data = {news: news}
      when 'activities'
        data = {activities: activities}
      else
        data = {}
    end
    if data.blank?
      render json: {
                 code: 0,
                 message: '未知类型'
             }
    else
      render json: {
                 code: 1,
                 data: data
             }
    end

  end
end
