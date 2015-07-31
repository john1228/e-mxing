class Appointment < ActiveRecord::Base
  include MessageAble
  belongs_to :coach
  belongs_to :user
  belongs_to :lesson
  has_many :appoint_logs, dependent: :destroy
  after_save :backend
  STATUS = {cancel: -1, waiting: 0, confirm: 1, finish: 2}

  def as_json
    sku_course = Sku.find_by(sku: sku)
    {
        id: Date.today.strftime('%Y-%m-%d')+'%05d' % id,
        course: sku_course.course.name,
        seller: sku_course.seller,
        amount: amount,
        created: created_at.localtime.strftime('%Y-%m-%d %H:%M')
    }
  end


  # def as_json(owner)
  #   if owner.eql?('coach')
  #     {
  #         id: id,
  #         course: {
  #             id: course.id,
  #             name: course.name,
  #             cover: course.cover,
  #             type: course.type,
  #             style: course.style,
  #             during: course.during
  #         },
  #         user: user.profile.summary_json.merge(contact: {name: lesson.contact_name, photo: lesson.contact_phone}),
  #         amount: amount,
  #         status: status,
  #         created: created_at.to_i
  #     }
  #   else
  #     {
  #         id: id,
  #         course: {
  #             id: course.id,
  #             name: course.name,
  #             cover: course.cover,
  #             type: course.type,
  #             style: course.style,
  #             during: course.during
  #         },
  #         coach: {
  #             mxid: coach.profile.mxid,
  #             name: coach.profile.name||'',
  #             avatar: coach.profile.avatar.thumb.url,
  #             gender: coach.profile.gender||1,
  #             age: coach.profile.age,
  #             signature: coach.profile.signature,
  #             tags: coach.profile.tags,
  #             mobile: coach.mobile,
  #             score: coach.score
  #         },
  #         amount: amount,
  #         status: status,
  #         created: created_at.to_i
  #     }
  #   end
  # end

  private
  def backend
    log = appoint_logs.create(appointment_id: id, status: status)
    if log.present?
      lesson.update(used: (lesson.used + amount)) if status.eql?(STATUS[:waiting])
      case status
        when STATUS[:cancel]
          #取消
          lesson.update(used: (lesson.used - amount))
          #通知私教 1-消息推送 2短信推送
          push(coach, "学员#{user.profile.name}已取消上课，赶快登陆查看，若有疑问，请联系学员。")
        when STATUS[:waiting]
          push(user, "您的私教#{coach.profile.name}已邀约您上#{course.name}课，进入查看您的私人课时,小伙伴们，确认课时后别忘记评价下私教哟。")
        when STATUS[:confirm]
          if course.guarantee.eql?(Course::GUARANTEE)
            services = ServiceMember.select(:service_id).where(coach: coach).uniq
            if services.size==1
              service = services.take.service
              #挂在单加服务号时，钱转给服务号
              wallet = Wallet.find_or_create_by(user: service)
              #购买时课程单价
              wallet.update(balance: (wallet.balance + course.price*amount), action: WalletLog::ACTIONS['卖课收入'])
            else
              #挂在多家结构时,钱直接转给私教
              wallet = Wallet.find_or_create_by(user: coach)
              wallet.update(balance: (wallet.balance + course.price*amount), action: WalletLog::ACTIONS['卖课收入'])
            end
          end
          push(coach, "学员#{user.profile.name}已确认上课，别忘记提醒学员评价，增加您的人气哟。")
        when STATUS[:finish]
          #TODO: 评论之后暂时什么都不做
      end
    end
  end
end
