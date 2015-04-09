class Group < ActiveRecord::Base
  include GroupConcern
  scope :recommend, ->() {}

  def as_json
    {
        no: id,
        name: name,
        photos: group_photos.collect { |photo|
          {
              thumb: $host + photo.photo.thumb.url,
              original: $hos + photo.photo.url
          }
        },
        members: {
            count: group_members.count,
            item: group_members.page(1).collect { |member| member.as_json }
        },
        interests: interests,
        intro: intro
    }
  end


  def summary_json
    {
        no: id,
        name: name,
        avatar: group_photos.first.present? ? group_photos.first.photo.url : '',
        intro: intro[0, 25],
        members: group_members.count
    }
  end
end
