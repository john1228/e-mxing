module Business
  module Students
    class HomeController < BaseController
      def index
        case params[:list]
          when 'mxing'
            students = Enthusiast.all
          when 'input'
            students = Enthusiast.all
          else
            students = []
        end
        render json: Success.new(student: students)
      end

      def create
        render json: Success.new
      end

      private
      def student_params
      end
    end
  end
end