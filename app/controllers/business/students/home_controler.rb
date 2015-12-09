module Business
  module Students
    class HomeController < BaseController

      def member
        render json: Success.new(
                   member: @coach.members.order(id: :desc).page(params[:page]||1).map { |member|
                     member.as_json(only: [:name, :mobile], methods: :avatar_url)
                   }
               )
      end

      def mxing
        render json: Success.new(
                   student: @coach.lessons.select('DISTINCT(user_id) user_id').where('available > used').page(params[:page]||1).map { |lesson|
                     user_profile = Profile.find_by(user_id: lesson.user_id)
                     {
                         mxid: user_profile.mxid,
                         name: HarmoniousDictionary.clean(user_profile.name||''),
                         avatar: user_profile.avatar.url,
                         gender: user_profile.gender||1,
                         age: user_profile.age,
                         true_age: user_profile.age,
                         signature: HarmoniousDictionary.clean(user_profile.signature),
                         identity: Profile.identities[user_profile.identity],
                         tags: user_profile.tags,
                         contact: lesson.where('available > used and user_id=?', lesson.user_id).map { |user_lesson|
                           {
                               name: user_lesson.order.contact_name,
                               mobile: user_lesson.order.contact_phone
                           }
                         }

                     }
                   }
               )
      end

      def create
        member = @coach.member.new(member_params)
        if member.save
          render json: Success.new
        else
          render json: Failure.new(member.errors.messages.join(';'))
        end
      end

      private
      def member_params
        params.permit(:name, :avatar, :mobile)
      end
    end
  end
end