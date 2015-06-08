class Comment < ActiveRecord::Base
  has_many :comment_images, dependent: :destroy
  belongs_to :user

  def as_json
    {
        content: content,
        images: comment_images.collect { |comment_image|
          comment_image.thumb.url
        },
        user: user.profile.summary_json
    }
  end
end
