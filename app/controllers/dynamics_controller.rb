class DynamicsController < ApplicationController
  include CheckConcern

  def index
    render json: {
               code: 1,
               data: {
                   dynamics: @user.dynamics.order(created_at: :desc).page(params[:page]||1).collect { |dynamic| dynamic.as_json }
               }
           }
  end

  def latest
    latest = @user.dynamics.latest.summary_json
    if latest.nil?
      render json: {
                 code: 0,
                 message: '还未发布动态'
             }
    else
      render json: {
                 code: 1,
                 data: {
                     dynamic: @user.dynamics.latest.summary_json
                 }
             }
    end
  end

  def create
    dynamic = @user.dynamics.new(content: params[:content])
    if dynamic.save
      (0...10).each { |image_index| dynamic.dynamic_images.create(image: params["#{image_index}"]) if params["#{image_index}"].present? }
      dynamic.create_dynamic_film(cover: params[:cover], film: params[:film]) if params[:film].present?&&params[:cover].present?
      render json: {
                 code: 1
             }
    else
      render json: {
                 code: 0,
                 message: '发布动态失败'
             }
    end
  end


  def destroy
    dynamic = @user.dynamics.find_by(id: params[:id])
    if dynamic.nil?
      render json: {
                 code: 0,
                 message: '该动态已经被删除'
             }
    else
      if dynamic.destroy
        render json: {code: 1}
      else
        render json: {code: 0, message: '删除动态失败'}
      end
    end
  end

end

