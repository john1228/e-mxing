class Enthusiast<User
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
        photowall: photos.map{|photo| {no: photo.id, url: photo.url}},
        target: profile.target,
        hobby: _hobby,
        often: profile.often_stadium,
        skill: profile.skill
    }
  end

  private
  def _hobby
    choose_interests = INTERESTS['items'].select { |item| profile.hobby.include?(item['id']) }
    choose_interests.collect { |choose| choose['name'] }
  end
end