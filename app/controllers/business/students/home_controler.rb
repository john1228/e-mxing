module Business
  module Students
    class HomeController < BaseController
      def index
        case params[:type]
          when 'member'
            render json: Success.new(
                       member: @coach.members.order(id: :desc).map { |member|
                         {
                             id: member.id,
                             name: member.name,
                             avatar: member.avatar.url,
                             mobile: member.mobile
                         }
                       }
                   )
          when 'mxing'
            render json: Success.new(
                       student: @coach.lessons.select('DISTINCT(user_id) user_id').where('available > used').map { |lesson|
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
                             contact: Lesson.where('available > used and user_id=? and coach_id=?', lesson.user_id, @coach.id).map { |user_lesson|
                               {
                                   name: user_lesson.order.contact_name,
                                   mobile: user_lesson.order.contact_phone,
                                   course_name: user_lesson.course.name
                               }
                             }

                         }
                       }
                   )
          else
            render json: Success.new
        end
      end


      def create
        member = @coach.members.new(member_params)
        if member.save
          render json: Success.new
        else
          render json: Failure.new(member.errors.messages.values.join(';'))
        end
      end

      def destroy
        case params[:type]
          when 'member'
            member = @coach.members.find(params[:id])
            if member.destroy
              render json: Success.new
            else
              render json: Failure.new('删除失败:'+member.errors.messages.values.join(';'))
            end
          else
            render json: Failure.new('无效的请求')
        end
      end

      private
      def member_params
        params.permit(:name, :avatar, :mobile)
      end
    end
  end
end