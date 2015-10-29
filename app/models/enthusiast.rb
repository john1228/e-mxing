class Enthusiast<User
  default_scope { joins(:profile).where('profiles.identity' => 0) }

  def detail
    detail = {
        mxid: profile.mxid,
        name: profile.name,
        avatar: {
            thumb: profile.avatar.url,
            origin: profile.avatar.url
        },
        tag: profile.tags,
        gender: profile.gender||1,
        age: profile.age,
        address: profile.address,
        signature: profile.signature,
        likes: likes.count,
        photowall: photos,
        target: profile.target,
        hobby: _hobby,
        often: profile.often_stadium,
        skill: profile.skill,
        dynamic: dynamics.order(id: :desc).page(1).map { |dynamic|
          json_str = {
              id: dynamic.id,
              content: dynamic.content
          }
          json_str = json_str.merge(image: dynamic.dynamic_images.first.image.url) if dynamic.dynamic_images.present?
          json_str = json_str.merge(film: dynamic.dynamic_film.cover.url) if dynamic.dynamic_film.present?
          json_str
        }
    }
    detail = detail.merge(showtime: {
                              id: showtime.id,
                              cover: showtime.dynamic_film.cover.url,
                              film: showtime.dynamic_film.film.hls
                          }) if showtime.present?
    detail
  end

  private
  def _hobby
    choose_interests = INTERESTS['items'].select { |item| profile.hobby.include?(item['id']) }
    choose_interests.collect { |choose| choose['name'] }
  end
end