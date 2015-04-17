class SystemController < ApplicationController
  before_action :find_user

  def feedback
    Feedback.create(user_id: @user.id, content: params[:content], contact: params[:contact])
    render json: {code: 1}
  end

  def report
    Report.create(user_id: @user.id, report_type: params[:type], report_id: params[:id], content: params[:content])
    render json: {code: 1}
  end

  private
  def find_user
    @user = Rails.cache.fetch(request.headers[:token])
    render json: {code: 0, message: '您还未登录'} if @user.blank?
  end
end
