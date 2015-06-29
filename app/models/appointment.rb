class Appointment < ActiveRecord::Base
  belongs_to :coach
  belongs_to :user
  belongs_to :course
  belongs_to :lesson

  after_save :backend
  after_create :notice
  STATUS = {cancel: -1, waiting: 0, confirm: 1, finish: 2}

  def as_json(owner)
    if owner.eql?('user')
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
          coach: coach.profile.summary_json,
          amount: amount,
          status: status,
          created: created_at.to_i
      }
    end
  end

  private
  def backend
    lesson.update(used: (lesson.used + amount)) if status.eql?(STATUS[:waiting])
    lesson.update(used: (lesson.used - amount)) if status.eql?(STATUS[:cancel])
  end

  def notice
    #通知学员
  end
end
