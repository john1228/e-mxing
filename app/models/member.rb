class Member < ActiveRecord::Base
  belongs_to :coach
  mount_uploader :avatar, ProfileUploader
end
