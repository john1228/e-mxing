module Business
  class LoginController < BaseController

    def feedback
      Feedback.create(user_id: @coach.id, content: params[:content], contact: params[:contact])
      render json: {code: 1}
    end
  end
end