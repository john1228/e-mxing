class HActivity < ActiveRecord::Base
  has_many :intro, class: HActivityIntro, dependent: :delete_all
  has_many :applies, foreign_key: :activity_id, dependent: :destroy
  has_many :comments, class: ActivityComment
  mount_uploader :cover, ActivityCoverUploader
  accepts_nested_attributes_for :intro
end
