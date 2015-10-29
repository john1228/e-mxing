module Api
  class KnowledgeController < ApplicationController
    def index
      week_rank = (Rails.cache.fetch('week')||{})
      week_rank.delete_if { |k, v| User.find_by(id: k).blank? }
      month_rank = (Rails.cache.fetch('month')||{})
      month_rank.delete_if { |k, v| User.find_by(id: k).blank? }

      render json: Success.new(
                 talent: {
                     week: {
                         week: Date.today.strftime('%U').to_i,
                         items: week_rank.map { |k, v|
                           user = User.find_by(id: k)
                           {user: user.summary_json, likes: v} if user.present?
                         }
                     },
                     month: {
                         items: month_rank.map { |k, v|
                           user = User.find_by(id: k)
                           {user: user.summary_json, likes: v} if user.present?
                         }
                     }
                 }
             )
    end
  end
end
