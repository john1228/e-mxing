module Business
  class ClocksController < BaseController
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