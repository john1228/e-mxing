class Enthusiast<User
  default_scope { joins(:profile).where('profiles.identity' => 0) }

  def detail
    detail = {
        mxid: profile.mxid,
        name: profile.name,
        avatar: {
            thumb: profile.avatar.thumb.url,
            origin: profile.avatar.url
        },
        tag: profile.tags,
        address: profile.address,
        intro: profile.signature,
        likes: likes.count,
        photowall: photos,
        target: profile.target,
        hobby: _hobby,
        often: profile.often_stadium,
        skill: profile.skill,
        dynamics: dynamics.order(id: :desc).page(1)
    }
    detail = detail.merge(showtime: {
                              cover: showtime.dynamic_film.cover,
                              film: showtime.dynamic_film.film.hls
                          }) if showtime.present?
    detail
  end

  private
  def _hobby
    interests_ary = interests.split(',') rescue []
    choose_interests = INTERESTS['items'].select { |item| interests_ary.include?(item['id'].to_s) }
    choose_interests.collect { |choose| choose['name'] }
  end
end