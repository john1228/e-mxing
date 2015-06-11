class WalletController < ApplicationController
  before_action :verify_auth_token

  def index
    @user.create_wallet if @user.wallet.blank?
    render json: Success.new(wallet: @user.wallet)
  end

  def coupons
    render json: Success.new(coupons: Coupon.where(id: @user.wallet.coupons.split(',')))
  end

  private
  def verify_auth_token
    @user = Rails.cache.fetch(request.headers[:token])
    render json: Failure.new('还没有登录') if @user.nil?
  end
end
