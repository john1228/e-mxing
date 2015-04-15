class Group < ActiveRecord::Base
  include GroupAble
  scope :recommend, ->() {}

  def as_json
    {
        no: id,
        easemob_id: easemob_id,
        name: name,
        photos: group_photos.collect { |photo|
          {
              thumb: $host + photo.photo.thumb.url,
              original: $host + photo.photo.url
          }
        },
        owner: User.find_by_mxid(owner).profile.summary_json,
        interests: interests,
        intro: intro
    }
  end


  def summary_json
    {
        no: id,
        easemob_id: easemob_id,
        name: name,
        avatar: group_photos.first.present? ? group_photos.first.photo.url : '',
        intro: intro[0, 25]
    }
  end
end
