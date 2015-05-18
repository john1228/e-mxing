class CoachDoc < ActiveRecord::Base
  belongs_to :coach
  mount_uploader :image, PhotoUploader
end
