class Comment < ActiveRecord::Base
  default_scope { where('1=1').order(id: :desc) }
  has_many :comment_images, dependent: :destroy
  belongs_to :user

  def as_json
    {
        content: content,
        images: comment_images.collect { |comment_image|
          comment_image.image.thumb.url
        },
        user: user.profile.summary_json,
        created: created_at.to_i
    }
  end
end
