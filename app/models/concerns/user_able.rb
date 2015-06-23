module UserAble
  extend ActiveSupport::Concern
  included do
    before_create :build_default_profile
    before_save :encrypted_password
    after_update :update_profile
  end

  private
  def build_default_profile
    if avatar.is_a?(String)
      build_profile(name: name,
                    remote_avatar_url: avatar,
                    gender: identity.eql?(2) ? 2 : (gender||1),
                    signature: signature||'这家伙很懒,什么也没留下',
                    identity: identity||0,
                    birthday: birthday.blank? ? Date.today.prev_year(15) : birthday,
                    address: address||'',
                    target: target||'',
                    skill: skill||'',
                    often: often||'',
                    interests: interests||'')
    else
      build_profile(name: name,
                    avatar: avatar,
                    gender: identity.eql?(2) ? 2 : (gender||1),
                    signature: signature||'这家伙很懒,什么也没留下',
                    identity: identity||0,
                    birthday: birthday.blank? ? Date.today.prev_year(15) : birthday,
                    address: address||'',
                    target: target||'',
                    skill: skill||'',
                    often: often||'',
                    interests: interests||'')
    end
    true
  end

  def encrypted_password
    if password.present? && password.length==32
    else
      salt_arr = %w"a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9"
      self.salt = salt_arr.sample(18).join
      self.password = Digest::MD5.hexdigest("#{password}|#{self.salt}")
    end
  end

  def update_profile
    update_avatar = avatar||profile_avatar
    update_params = {
        name: name||profile_name,
        gender: gender||profile_gender,
        signature: signature||'这家伙很懒,什么也没留下',
        birthday: birthday.blank? ? Date.today.prev_year(15) : birthday,
        address: address||profile_address,
        target: target||profile_target,
        skill: skill||profile_skill,
        often: often||profile_often,
        identity: identity||profile_identity,
        interests: interests||profile_interests
    }
    update_params = update_params.merge(avatar: update_avatar) unless update_avatar.is_a?(String)
    profile.update(update_params)
  end
end