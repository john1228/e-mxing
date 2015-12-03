module Business
  module Students
    class HomeController < BaseController
      def index
        case params[:list]
          when 'member'
            students = @coach.members.order(id: :desc).page(params[:page]||1).map { |member|
              {
                  name: member.name,
                  avatar: member.avatar.url,
                  mobile: member.mobile
              }
              member.as_json(only: [:name, :mobile], methods: :avatar)
            }
          when 'mxing'
            students = @coach.lessons.select('DISTINCT(user_id) user_id').where('available > used').page(params[:page]||1).map { |lesson|
              latest_lesson = Lesson.where(user_id: lesson.user_id).order(id: :desc).take
              {
                  mxid: lesson.user.profile.mxid,
                  name: HarmoniousDictionary.clean(lesson.user.profile.name||''),
                  avatar: lesson.user.profile.avatar.url,
                  gender: lesson.user.profile.gender||1,
                  age: lesson.user.profile.age,
                  true_age: lesson.user.profile.age,
                  signature: HarmoniousDictionary.clean(lesson.user.profile.signature),
                  identity: Profile.identities[lesson.user.profile.identity],
                  tags: lesson.user.profile.tags,
                  contact: latest_lesson.contact_phone
              }
            }
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