module Mine
  class WalletController < BaseController
    def index
      @me.create_wallet if @me.wallet.blank?
      render json: Success.new(wallet: @me.wallet)
    end

    def coupons
      render json: Success.new(coupons: Coupon.where(id: @me.wallet.coupons).page(params[:page]||1))
    end

    def detail
      render json: Success.new(detail: @me.wallet.wallet_logs.where('balance <> 0').page(params[:page]||1).map { |log|
                                 {
                                     id: log.id_string,
                                     action: log.action_name,
                                     balance: log.balance.to_f.round(2),
                                     created: log.created_at.to_i
                                 }
                               })
    end

    def exchange
      if params[:code].eql?('qwer1234')
        render json: Success.new
      else
        coupon = Coupon.where('? = ANY (code) and amount > used', params[:code]).take
        if coupon.blank?
          begin
            if coupon.update(used: (coupon.used + 1))
              wallet = @me.wallet
              wallet.with_lock do
                wallet.coupons << coupon.id
                wallet.action = WalletLog::ACTIONS['兑换']
                wallet.save
              end
              render json: Success.new
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
end