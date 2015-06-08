class Comment < ActiveRecord::Base
  has_many :comment_images, dependent: :destroy
end
