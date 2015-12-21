module Business
  class ClocksController < BaseController
    def index
      render json: Success.new(
                 clock: @coach.clocks.order(id: :desc).page(params[:page]||1).map { |clock|
                   {
                       created: clock.created_at.strftime('%Y-%m-%d %H:%M:%S')
                   }
                 }
             )
    end

    def create
      clock = Clock.new(coach: @coach)
      if clock.save
        render json: Success.new
      else
        render json: Failure.new(clock.errors.messages.join(";"))
      end
    end
  end
end