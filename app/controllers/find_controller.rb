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

  def tips
    render json: {
               code: 1,
               data: {
                   group: '找到一起健身到小伙伴',
                   service: '健身房开通啦,快快来关注',
                   news: News.last.title||'还没有新闻',
                   activity: Activity.last.title||'还没有活动'
               }
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
