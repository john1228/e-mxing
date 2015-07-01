class Appointment < ActiveRecord::Base
  belongs_to :coach
  belongs_to :user
  belongs_to :course
  belongs_to :lesson

  after_save :backend
  after_create :notice
  STATUS = {cancel: -1, waiting: 0, confirm: 1, finish: 2}

  def as_json(owner)
    if owner.eql?('coach')
      {
          id: id,
          course: {
              id: course.id,
              name: course.name,
              cover: (course.course_photos.first.photo.thumb.url rescue ''),
              type: course.type,
              style: course.style,
              during: course.during
          },
          user: user.profile.summary_json.merge(contact: {name: lesson.contact_name, photo: lesson.contact_phone}),
          amount: amount,
          status: status,
          created: created_at.to_i
      }
    else
      {
          id: id,
          course: {
              id: course.id,
              name: course.name,
              cover: (course.course_photos.first.photo.thumb.url rescue ''),
              type: course.type,
              style: course.style,
              during: course.during
          },
          coach: {
              mxid: coach.profile.mxid,
              name: coach.profile.name||'',
              avatar: coach.profile.avatar.thumb.url,
              gender: coach.profile.gender||1,
              age: coach.profile.age,
              signature: coach.profile.signature,
              tags: coach.profile.tags,
              mobile: coach.mobile,
              score: coach.score
          },
          amount: amount,
          status: status,
          created: created_at.to_i
      }
    end
  end

  private
  def backend
    lesson.update(used: (lesson.used + amount)) if status.eql?(STATUS[:waiting])
    if status.eql?(STATUS[:cancel])
      lesson.update(used: (lesson.used - amount))
      #通知私教 1-消息推送 2短信推送
      send(coach, "学员#{user.profile.name}已取消上课，赶快登陆查看，若有疑问，请联系学员。")
    end
    if status.eql?(STATUS[:confirm])
      send(coach, "学员#{user.profile.name}已确认上课，别忘记提醒学员评价，增加您的人气哟。")
    end
  end

  def notice
    #通知学员 1-消息推送 2短信推送
    send(user, "您的私教#{coach.profile.name}已邀约您上#{course.name}课，进入查看您的私人课时,小伙伴们，确认课时后别忘记评价下私教哟。")
  end
end
