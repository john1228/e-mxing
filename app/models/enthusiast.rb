class Enthusiast<User
  has_one :profile, foreign_key: :user_id
  default_scope { joins(:profile).where('profiles.identity' => 0) }

  def detail
    {
        mxid: profile.mxid,
        name: profile.name,
        avatar: profile.avatar.url,
        tag: profile.tags,
        gender: profile.gender||1,
        age: profile.age,
        address: profile.address,
        signature: profile.signature,
        likes: likes.count,
        photowall: photos.map { |photo| {no: photo.id, url: photo.url} },
        target: profile.target,
        fpg: profile._fitness_program,
        often: profile.often_stadium,
        skill: profile.skill
    }
  end

  undef as_json
end