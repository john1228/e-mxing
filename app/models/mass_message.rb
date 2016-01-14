class MassMessage < ActiveRecord::Base

  Member.all.each { |member|
    if member.user.present?
      member.update(gender: member.user.profile.gender, member_type: 0)
    else
      user = User.find_by(mobile: member.mobile)
      if user.blank?
        user = User.create(mobile: member.mobile, password: '12345678', profile_attributes: {name: member.name})
      end
      member.update(user_id: user.id)
    end
  }

end
