class Comment < ActiveRecord::Base
  default_scope { order(id: :desc) }
  belongs_to :user
  belongs_to :course, counter_cache: true
  mount_uploaders :images,ImagesUploader

  def as_json
    {
        content: HarmoniousDictionary.clean(content),
        images: image.map{|item|
          {
              thumb: item.thumb.url,
              original: item.url
          }
        },
        user: user.profile.summary_json,
        created: created_at.to_i
    }
  end
end
