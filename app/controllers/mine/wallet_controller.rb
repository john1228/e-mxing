module Mine
  class WalletController < BaseController
    def index
      @user.create_wallet if @user.wallet.blank?
      render json: Success.new(wallet: @user.wallet)
    end

    def coupons
      render json: Success.new(coupons: Coupon.where(id: @user.wallet.coupons).page(params[:page]||1))
    end

    def detail
      render json: Success.new(detail: @user.wallet.wallet_logs.where.not(balance: 0).page(params[:page]||1))
    end

    def exchange
      coupon = Coupon.where('? = ANY (code) and amount > used', params[:code]).take
      if coupon.blank?
        begin
          if coupon.update(used: (coupon.used + 1))
            wallet = @user.wallet
            wallet.with_lock do
              wallet.coupons << coupon.id
              wallet.action = WalletLog::ACTIONS['兑换']
              wallet.save
            end
          else
            render json: Failure.new('兑换失败')
          end
        rescue
          render json: Failure.new('兑换失败')
        end
      else
        render json: Failure.new('无效的兑换码')
      end
    end
  end
end