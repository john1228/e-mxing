module UserAble
  extend ActiveSupport::Concern


  private
  def build_default_profile
    if avatar.is_a?(String)
      build_profile(
          name: name,
          remote_avatar_url: avatar,
          gender: identity.eql?(2) ? 2 : (gender||1),
          signature: signature||'',
          identity: identity||0,
          birthday: birthday,
          address: address||'',
          target: target||'',
          skill: skill||'',
          often: often||'',
          service: service,
          interests: (interest.join(',') rescue ''),
          mobile: mobile.to_s.length.eql?(13) ? mobile : contact
      )
    else
      build_profile(
          name: name,
          avatar: avatar,
          gender: identity.eql?(2) ? 2 : (gender||1),
          signature: signature||'',
          identity: identity||0,
          birthday: birthday,
          address: address||'',
          target: target||'',
          skill: skill||'',
          often: often||'',
          service: service,
          interests: (interest.join(',') rescue ''),
          mobile: mobile.to_s.length.eql?(13) ? mobile : contact
      )
    end
    true
  end
end